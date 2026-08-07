#!/usr/bin/env python3
from __future__ import annotations
import argparse, math
from pathlib import Path
import numpy as np
import trimesh
from PIL import Image, ImageDraw, ImageFont

SELECTED = [
 'house_founders','community_center','cafe','tree_deciduous','fridge_basic','bed_double','sofa_basic','computer_basic',
 'easel_basic','chess_table','telescope_basic','gym_treadmill','alchemy_station','future_workbench','pet_dog','pet_horse',
 'kitchen_stove','television_basic','sculpting_station','nectar_maker','inventing_bench','sim_avatar_reference',
 'mailbox_basic','garden_planter','piano_upright','mixology_bar','treehouse','festival_booth','time_portal','resort_tower',
 'luxury_lounge_chair','sport_car_display','community_locker','spa_vanity','candy_floor_lamp','industrial_coffee_table',
 'retro_dance_console','movie_prop_statue','performance_stage'
]

def mat_color(geom):
    mat=getattr(getattr(geom,'visual',None),'material',None)
    base=getattr(mat,'baseColorFactor',None)
    if base is None: return (165,170,175)
    arr=np.asarray(base,dtype=float).reshape(-1)
    if arr.max()<=1.01: arr=arr*255
    return tuple(int(max(0,min(255,x))) for x in arr[:3])

def render_model(path: Path, size=220):
    sc=trimesh.load(path,force='scene')
    geoms=list(sc.geometry.values())
    if not geoms: return Image.new('RGB',(size,size),'#263039')
    allv=np.vstack([g.vertices for g in geoms if len(g.vertices)])
    center=(allv.min(0)+allv.max(0))/2; span=max(float((allv.max(0)-allv.min(0)).max()),1e-3)
    ay=math.radians(42); ax=math.radians(28)
    Ry=np.array([[math.cos(ay),0,math.sin(ay)],[0,1,0],[-math.sin(ay),0,math.cos(ay)]])
    Rx=np.array([[1,0,0],[0,math.cos(ax),-math.sin(ax)],[0,math.sin(ax),math.cos(ax)]])
    R=Rx@Ry
    faces=[]
    scale=(size*0.68)/span
    for g in geoms:
        v=(g.vertices-center)@R.T
        col=mat_color(g)
        for face in g.faces:
            pts=v[face]
            n=np.cross(pts[1]-pts[0],pts[2]-pts[0]); nl=np.linalg.norm(n)
            if nl<1e-9: continue
            n=n/nl
            light=max(.25,min(1.0,.62+.38*np.dot(n,np.array([-.3,.7,.65]))))
            shaded=tuple(int(c*light) for c in col)
            xy=np.column_stack((pts[:,0]*scale+size/2, -pts[:,1]*scale+size*.58))
            faces.append((float(pts[:,2].mean()),xy,shaded))
    img=Image.new('RGB',(size,size),'#e9edf0'); d=ImageDraw.Draw(img)
    for _,xy,col in sorted(faces,key=lambda x:x[0]):
        poly=[(float(x),float(y)) for x,y in xy]
        d.polygon(poly,fill=col,outline=tuple(max(0,c-30) for c in col))
    return img

def sheet(folder:Path,out:Path,title:str):
    paths={p.stem:p for p in folder.glob('*.glb')}
    names=[n for n in SELECTED if n in paths]
    # fill with first additional names if a baseline lacks later assets
    cols=5; tile=220; label=34; header=58
    rows=math.ceil(len(names)/cols)
    canvas=Image.new('RGB',(cols*tile,header+rows*(tile+label)),'#182128'); d=ImageDraw.Draw(canvas)
    d.text((16,16),title,fill='#f3f7f8')
    for i,name in enumerate(names):
        x=(i%cols)*tile; y=header+(i//cols)*(tile+label)
        canvas.paste(render_model(paths[name],tile),(x,y))
        d.rectangle((x,y+tile,x+tile,y+tile+label),fill='#222d35')
        d.text((x+8,y+tile+8),name.replace('_',' '),fill='#edf3f5')
    out.parent.mkdir(parents=True,exist_ok=True); canvas.save(out,optimize=True)
    print(out)

if __name__=='__main__':
    ap=argparse.ArgumentParser(); ap.add_argument('folder',type=Path); ap.add_argument('out',type=Path); ap.add_argument('--title',default='OpenLife asset contact sheet'); a=ap.parse_args(); sheet(a.folder,a.out,a.title)
