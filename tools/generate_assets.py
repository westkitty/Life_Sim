#!/usr/bin/env python3
"""Generate OpenLife-owned low-poly GLB assets and synthesized WAV SFX.

All outputs are original procedural geometry/audio created for OpenLife. No third-party
asset bytes are embedded. The generator is deterministic and safe to rerun.
"""
from __future__ import annotations
import json, math, hashlib, struct, wave
from pathlib import Path
import numpy as np
import trimesh
from trimesh.visual.material import PBRMaterial
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "generated"
MODEL_DIR = OUT / "models"
AUDIO_DIR = OUT / "audio"
UI_DIR = OUT / "ui"
TEXTURE_DIR = OUT / "textures"
for d in (MODEL_DIR, AUDIO_DIR, UI_DIR, TEXTURE_DIR): d.mkdir(parents=True, exist_ok=True)

PALETTE = {
    "cream": "#d8c7a2", "cream2": "#ece0c5", "blue": "#90b6c9", "rose": "#c99188",
    "green": "#63885f", "darkgreen": "#315a3b", "wood": "#75533b", "darkwood": "#463429",
    "roof": "#5b4d48", "road": "#51575c", "sidewalk": "#bdbab0", "white": "#f2f2ea",
    "metal": "#58656b", "black": "#252b2e", "glass": "#7eb6c7", "gold": "#c9a254",
    "purple": "#6d4f82", "teal": "#4d8f93", "red": "#bd5d52", "orange": "#c97a48",
    "yellow": "#d0b45f", "water": "#55a9bd", "stone": "#817f79", "skin": "#b97f5d",
}

def rgba(hexcolor: str, alpha: int = 255):
    h = hexcolor.lstrip('#'); return tuple(int(h[i:i+2],16) for i in (0,2,4)) + (alpha,)

def material(name: str, color: str, metallic=0.0, rough=0.75):
    return PBRMaterial(name=name, baseColorFactor=np.array(rgba(color))/255.0, metallicFactor=metallic, roughnessFactor=rough)

MATS = {k: material(k,v, metallic=(0.45 if k in {"metal","gold"} else 0.0), rough=(0.35 if k in {"metal","glass","gold"} else 0.8)) for k,v in PALETTE.items()}

def box(extents, pos, mat="cream"):
    m=trimesh.creation.box(extents=extents); m.apply_translation(pos); m.visual.material=MATS[mat]; return m

def cyl(radius, height, pos, mat="metal", sections=18):
    m=trimesh.creation.cylinder(radius=radius, height=height, sections=sections); m.apply_translation(pos); m.visual.material=MATS[mat]; return m

def sphere(radius, pos, mat="green", subdivisions=2):
    m=trimesh.creation.icosphere(subdivisions=subdivisions, radius=radius); m.apply_translation(pos); m.visual.material=MATS[mat]; return m

def cone(radius, height, pos, mat="roof", sections=16):
    m=trimesh.creation.cone(radius=radius, height=height, sections=sections); m.apply_translation(pos); m.visual.material=MATS[mat]; return m

def hip_roof(width, depth, height, pos, mat="roof"):
    m=trimesh.creation.cone(radius=1.0, height=height, sections=4)
    # Rotate square base from diamond orientation and scale independently.
    m.apply_transform(trimesh.transformations.rotation_matrix(math.radians(45), [0,0,1]))
    m.apply_scale([width/math.sqrt(2), depth/math.sqrt(2), height/max(height,1e-6)])
    # trimesh cone height axis is Z; map to Godot Y-up.
    m.apply_transform(np.array([[1,0,0,0],[0,0,1,0],[0,-1,0,0],[0,0,0,1]],dtype=float))
    m.apply_translation(pos); m.visual.material=MATS[mat]; return m

def scene(parts):
    s=trimesh.Scene();
    for i,g in enumerate(parts): s.add_geometry(g, node_name=f"part_{i:02d}")
    return s

def export_asset(asset_id, parts, role, tags, nominal_size):
    path=MODEL_DIR/f"{asset_id}.glb"; path.write_bytes(scene(parts).export(file_type="glb"))
    return {"id":asset_id,"path":f"res://assets/generated/models/{path.name}","role":role,"tags":tags,"nominal_size":nominal_size,"sha256":hashlib.sha256(path.read_bytes()).hexdigest(),"bytes":path.stat().st_size}

assets=[]

# --- architecture ---------------------------------------------------------
def house(asset_id, wall, roof, variant=0):
    parts=[box((11.5,4.6,8.5),(0,2.3,0),wall),
           hip_roof(6.4,4.8,2.4,(0,5.55,0),roof),
           box((1.35,2.35,0.18),(0,1.18,4.34),"darkwood"),
           box((4.6,.20,2.2),(0,.10,5.10),"sidewalk")]
    # windows with trim, sill, mullions
    for x in (-3.4,3.4):
        parts += [box((1.55,1.65,.12),(x,2.55,4.38),"white"),box((1.32,1.42,.10),(x,2.55,4.46),"glass"),
                  box((.07,1.45,.08),(x,2.55,4.53),"white"),box((1.35,.07,.08),(x,2.55,4.53),"white"),
                  box((1.58,.10,.22),(x,1.73,4.43),"stone")]
    # porch posts, steps and chimney
    parts += [cyl(.12,2.35,(-1.7,1.18,4.9),"white",16),cyl(.12,2.35,(1.7,1.18,4.9),"white",16),
              box((2.3,.18,.6),(0,.18,6.0),"stone"),box((1.9,.16,.5),(0,.28,5.65),"stone"),
              box((.85,2.5,.85),(-4.8,5.1,-2.2),"stone")]
    if variant==1:
        parts += [box((3.0,2.7,3.2),(4.8,1.35,-2.0),wall),hip_roof(1.9,1.9,1.15,(4.8,3.25,-2.0),roof),box((1.2,1.2,.1),(4.8,1.7, -.35),"glass")]
    if variant==2:
        parts += [box((2.4,1.2,2.2),(-4.4,5.35,0),wall),hip_roof(1.6,1.5,.9,(-4.4,6.35,0),roof),box((1.0,.9,.1),(-4.4,5.45,1.12),"glass")]
    assets.append(export_asset(asset_id,parts,"building",["residential","suburban"],[12,7,11]))

house("house_founders","cream","roof",0)
house("house_blue","blue","roof",1)
house("house_rose","rose","darkwood",2)

assets.append(export_asset("community_center",[
    box((13,3.8,8),(0,1.9,0),"cream2"), box((13.6,0.4,8.6),(0,4.0,0),"teal"),
    box((4.0,2.7,0.15),(0,1.35,4.08),"glass"), box((5.0,0.2,2.0),(0,0.1,5.0),"sidewalk"),
    cyl(0.35,3.0,(-5.3,1.5,3.7),"white",10), cyl(0.35,3.0,(5.3,1.5,3.7),"white",10)
],"building",["community","rabbit_hole"],[14,5,10]))
assets.append(export_asset("cafe",[
    box((9.5,3.4,7),(0,1.7,0),"orange"), box((10.0,0.36,7.5),(0,3.58,0),"darkwood"),
    box((4.8,2.2,0.15),(0,1.45,3.58),"glass"), box((2.0,0.18,7.8),(-5.1,2.65,0),"yellow")
],"building",["community","restaurant"],[11,4,8]))
assets.append(export_asset("hospital_rabbit_hole",[
    box((15,5.4,9),(0,2.7,0),"white"), box((15.6,0.35,9.6),(0,5.55,0),"blue"),
    box((6.2,3.0,0.15),(0,1.7,4.58),"glass"), box((1.0,0.35,5.0),(0,6.2,0),"red"), box((5.0,0.35,1.0),(0,6.2,0),"red")
],"building",["community","rabbit_hole","career"],[16,7,10]))

# Roads / lot dressing
assets.append(export_asset("road_straight",[box((8,0.08,16),(0,0.04,0),"road"),box((0.18,0.04,16),(0,0.10,0),"yellow")],"road",["road","modular"],[8,0.15,16]))
assets.append(export_asset("road_cross",[box((22,0.08,8),(0,0.04,0),"road"),box((8,0.09,22),(0,0.05,0),"road")],"road",["road","intersection"],[22,0.15,22]))

# Nature
assets.append(export_asset("tree_deciduous",[cyl(.32,2.8,(0,1.4,0),"wood",9),sphere(1.45,(0,3.15,0),"darkgreen",2),sphere(.9,(.8,3.0,.25),"green",1)],"nature",["tree"],[3,4.8,3]))
assets.append(export_asset("tree_pine",[cyl(.25,2.3,(0,1.15,0),"wood",8),cone(1.5,3.5,(0,3.2,0),"darkgreen",10),cone(1.15,2.5,(0,4.15,0),"green",10)],"nature",["tree","pine"],[3,5.5,3]))
assets.append(export_asset("shrub",[sphere(.7,(-.4,.55,0),"green",1),sphere(.8,(.35,.65,.1),"darkgreen",1),sphere(.55,(0,.55,.5),"green",1)],"nature",["shrub"],[1.8,1.4,1.8]))
assets.append(export_asset("rock_cluster",[sphere(.6,(-.4,.38,0),"stone",1),sphere(.45,(.35,.30,.2),"stone",1),sphere(.32,(.15,.22,-.4),"stone",1)],"nature",["rock"],[1.6,.9,1.3]))

# Interactable object functions
def furniture(asset_id, parts, tags, size): assets.append(export_asset(asset_id,parts,"interactable",tags,size))

def chair_parts(color="wood", x=0.0, z=0.0):
    return [box((.58,.12,.58),(x,.52,z),color), box((.58,.72,.10),(x,.93,z-.24),color)] + [box((.07,.52,.07),(x+sx,.26,z+sz),"darkwood") for sx in (-.22,.22) for sz in (-.22,.22)]

def knob(pos, mat="metal"):
    return sphere(.055,pos,mat,1)

def screen_panel(size, pos):
    return [box(size,pos,"black"), box((size[0]*.88,size[1]*.80,.035),(pos[0],pos[1],pos[2]+size[2]*.55),"glass")]
furniture("fridge_basic",[box((1.25,2.15,1.05),(0,1.075,0),"white"),box((1.18,.05,.10),(0,1.22,.56),"metal"),box((.07,.72,.07),(.43,1.65,.58),"metal"),box((.07,.55,.07),(.43,.72,.58),"metal"),box((.42,.22,.035),(-.28,1.7,.59),"black"),cyl(.045,.12,(-.42,.10,-.38),"black",12),cyl(.045,.12,(.42,.10,-.38),"black",12)], ["kitchen","appliance"],[1.3,2.2,1.1])
furniture("toilet_basic",[box((.75,.75,.35),(0,.85,-.25),"white"),cyl(.48,.28,(0,.42,.15),"white",16),cyl(.32,.36,(0,.20,.1),"white",16)],["plumbing","bathroom"],[1,1.2,1.1])
furniture("shower_basic",[box((1.15,.08,1.15),(0,.04,0),"white"),box((.06,2.25,1.15),(-.55,1.12,0),"glass"),box((1.15,2.25,.06),(0,1.12,-.55),"glass"),cyl(.04,1.9,(.35,1.2,.3),"metal",8),sphere(.12,(.35,2.05,.3),"metal",1)],["plumbing","bathroom"],[1.2,2.3,1.2])
furniture("bed_double",[box((2.52,.30,2.20),(0,.34,0),"darkwood"),box((2.36,.30,1.88),(0,.62,.05),"blue"),box((2.36,.12,1.05),(0,.83,.38),"cream2"),box((2.52,1.18,.18),(0,.79,-1.02),"darkwood"),box((2.20,.16,.16),(0,.23,1.02),"wood"),box((.88,.20,.58),(-.56,.93,-.56),"white"),box((.88,.20,.58),(.56,.93,-.56),"white")]+[box((.09,.35,.09),(x,.17,z),"darkwood") for x in (-1.05,1.05) for z in (-.88,.88)], ["comfort","bedroom"],[2.6,1.4,2.3])
furniture("sofa_basic",[box((2.55,.42,.86),(0,.42,0),"orange"),box((2.55,.68,.24),(0,.92,-.34),"orange"),box((.30,.72,.94),(-1.16,.68,0),"orange"),box((.30,.72,.94),(1.16,.68,0),"orange"),box((1.02,.20,.72),(-.53,.72,.07),"rose"),box((1.02,.20,.72),(.53,.72,.07),"rose")]+[box((.09,.20,.09),(x,.10,z),"darkwood") for x in (-1.0,1.0) for z in (-.30,.30)], ["comfort","living"],[2.6,1.3,1])
furniture("bookshelf_basic",[box((1.55,2.05,.42),(0,1.025,0),"wood")]+[box((1.3,.08,.45),(0,.35+i*.5,.02),"darkwood") for i in range(4)],["study","storage"],[1.6,2.1,.5])
furniture("computer_basic",[box((1.55,.10,.80),(0,.78,0),"darkwood"),box((.68,.62,.10),(0,1.18,-.08),"black"),box((.57,.49,.035),(0,1.20,-.015),"glass"),box((.78,.055,.28),(0,.88,.28),"metal"),box((.42,.72,.45),(.52,.39,-.10),"black"),box((.18,.04,.12),(.32,.89,.28),"white"),cyl(.055,.34,(0,.98,-.08),"metal",12)]+[box((.10,.75,.10),(x,.38,z),"darkwood") for x in (-.65,.65) for z in (-.30,.30)], ["electronics","study","computer"],[1.6,1.6,.9])
furniture("stereo_basic",[box((1,.72,.52),(0,.36,0),"black"),cyl(.18,.04,(-.25,.4,.28),"metal",18),cyl(.18,.04,(.25,.4,.28),"metal",18)],["electronics","music"],[1,.75,.55])
furniture("easel_basic",[box((.08,1.8,.08),(-.35,.9,0),"wood"),box((.08,1.8,.08),(.35,.9,0),"wood"),box((.08,1.9,.08),(0,.95,.35),"wood"),box((.95,1.05,.06),(0,1.25,.05),"cream2")],["hobbies","painting"],[1.1,1.9,.7])
furniture("chess_table",[cyl(.12,.7,(0,.35,0),"wood",10),box((1.2,.10,1.2),(0,.75,0),"darkwood")]+[box((.13,.08,.13),(-.45+i*.3,.84,-.45+j*.3),"white" if (i+j)%2==0 else "black") for i in range(4) for j in range(4)],["hobbies","logic"],[1.4,.95,1.4])
furniture("grill_basic",[box((1.3,.65,.72),(0,1.0,0),"black"),cyl(.04,.75,(-.5,.38,-.25),"metal",8),cyl(.04,.75,(.5,.38,-.25),"metal",8),box((1.35,.08,.76),(0,1.35,0),"metal")],["outdoor","cooking"],[1.4,1.4,.8])
furniture("telescope_basic",[cyl(.16,1.2,(0,1.15,0),"metal",12),cyl(.32,.7,(0,1.75,0),"blue",12),box((.08,1.3,.08),(-.35,.65,.2),"metal"),box((.08,1.3,.08),(.35,.65,.2),"metal")],["hobbies","science"],[.9,2.2,.9])
furniture("park_bench",[box((2.3,.18,.55),(0,.55,0),"wood"),box((2.3,.18,.18),(0,1.05,-.22),"wood"),box((.12,.9,.12),(-.9,.45,0),"metal"),box((.12,.9,.12),(.9,.45,0),"metal")],["community","seating"],[2.4,1.2,.7])
furniture("gym_treadmill",[box((.9,.18,1.8),(0,.15,0),"black"),box((.75,.06,1.45),(0,.28,.1),"metal"),cyl(.04,1.15,(-.4,.86,-.65),"metal",8),cyl(.04,1.15,(.4,.86,-.65),"metal",8),box((.9,.12,.25),(0,1.42,-.65),"black")],["fitness","athletic"],[1.1,1.55,2])
furniture("alchemy_station",[box((1.8,.86,.95),(0,.43,0),"darkwood"),box((1.9,.10,1.02),(0,.91,0),"wood"),cyl(.38,.58,(-.48,1.18,0),"purple",24),cyl(.29,.46,(.38,1.10,.20),"teal",24),sphere(.22,(.40,1.47,.20),"gold",2),cyl(.07,.55,(0,1.22,-.20),"metal",16),sphere(.12,(0,1.55,-.20),"green",2),box((.42,.06,.28),(.48,1.0,-.28),"cream2")], ["supernatural","alchemy","magic"],[1.9,1.7,1.1])
furniture("future_workbench",[box((2.05,.86,1.12),(0,.43,0),"metal"),box((1.92,.11,.98),(0,.92,0),"teal"),cyl(.20,.78,(-.58,1.28,0),"gold",20),sphere(.26,(.48,1.30,.10),"teal",2),box((.75,.52,.06),(.32,1.55,-.28),"glass"),cyl(.08,.62,(.78,1.25,.18),"metal",16),sphere(.12,(.78,1.62,.18),"purple",2)], ["future","workbench","technology"],[2.2,1.9,1.25])
furniture("pet_bowl",[cyl(.4,.16,(0,.08,0),"red",18),cyl(.27,.12,(0,.16,0),"metal",18)],["pets","feeding"],[.8,.25,.8])
furniture("resort_desk",[box((2.4,1.1,.9),(0,.55,0),"cream"),box((2.5,.12,1.0),(0,1.16,0),"wood"),box((.45,.45,.08),(.65,1.45,0),"glass")],["resort","service"],[2.5,1.7,1])


furniture("kitchen_stove",[box((1.25,.9,1.05),(0,.45,0),"metal"),box((1.18,.10,1.0),(0,.95,0),"black"),box((.95,.48,.04),(0,.40,.55),"black"),box((.85,.38,.035),(0,.40,.575),"glass")]+[cyl(.17,.035,(x,1.02,z),"black",24) for x in (-.30,.30) for z in (-.25,.25)]+[knob((x,.82,.57),"metal") for x in (-.38,-.13,.13,.38)], ["kitchen","cooking","appliance"],[1.3,1.1,1.1])
furniture("kitchen_sink",[box((1.25,.85,.75),(0,.43,0),"cream2"),box((.8,.12,.5),(0,.93,0),"metal"),cyl(.04,.45,(0,1.16,-.14),"metal",10)], ["kitchen","plumbing"],[1.3,1.4,.8])
furniture("dining_table",[box((1.8,.12,1.2),(0,.82,0),"wood")]+[box((.12,.8,.12),(x,.4,z),"darkwood") for x in (-.7,.7) for z in (-.4,.4)], ["dining","surface"],[1.9,1,1.3])
furniture("dining_chair",[box((.55,.12,.55),(0,.55,0),"wood"),box((.55,.75,.12),(0,.95,-.22),"wood")]+[box((.08,.55,.08),(x,.27,z),"darkwood") for x in (-.2,.2) for z in (-.2,.2)], ["dining","seating"],[.7,1.4,.7])
furniture("television_basic",[box((1.55,.94,.13),(0,1.18,0),"black"),box((1.39,.78,.035),(0,1.18,.08),"glass"),box((.11,.62,.11),(0,.52,0),"metal"),box((.78,.09,.44),(0,.20,0),"metal"),box((1.15,.14,.40),(0,.10,0),"darkwood"),knob((.64,.88,.09),"red")], ["electronics","fun"],[1.6,1.75,.55])
furniture("desk_basic",[box((1.7,.12,.8),(0,.85,0),"wood"),box((.12,.82,.12),(-.68,.41,-.25),"darkwood"),box((.12,.82,.12),(.68,.41,-.25),"darkwood"),box((.45,.65,.7),(.55,.42,.02),"wood")], ["study","surface"],[1.8,1.1,.9])
furniture("dresser_basic",[box((1.45,1.25,.55),(0,.625,0),"wood")]+[box((1.25,.04,.04),(0,.3+i*.3,.3),"metal") for i in range(3)], ["bedroom","storage"],[1.5,1.3,.6])
furniture("bathtub_basic",[box((1.1,.55,2.0),(0,.42,0),"white"),box((.8,.28,1.65),(0,.58,0),"water"),cyl(.04,.35,(0,.85,-.75),"metal",8)], ["bathroom","plumbing"],[1.2,1.1,2.1])
furniture("crib_basic",[box((1.1,.16,1.75),(0,.35,0),"cream2")]+[cyl(.035,.75,(x,.72,z),"wood",8) for x in (-.48,.48) for z in (-.7,-.4,-.1,.2,.5,.7)], ["nursery","baby"],[1.2,1.2,1.9])
furniture("guitar_basic",[box((.16,.85,.12),(0,1.05,0),"wood"),sphere(.34,(0,.52,0),"orange",2),sphere(.24,(0,.82,0),"orange",2),cyl(.09,.05,(0,.58,.15),"black",16)], ["music","hobby"],[.8,1.7,.5])
furniture("laundry_washer",[box((1.15,1.2,1.0),(0,.6,0),"white"),cyl(.35,.08,(0,.62,.54),"glass",20),box((.8,.12,.08),(0,1.05,.54),"metal")], ["laundry","appliance","ambitions"],[1.2,1.3,1.1])
furniture("hot_tub",[box((2.3,.72,2.3),(0,.36,0),"wood"),cyl(.9,.45,(0,.62,0),"water",24),cyl(1.05,.08,(0,.88,0),"cream2",24)], ["outdoor","social","luxury"],[2.5,1.1,2.5])
furniture("arcade_machine",[box((.95,1.75,.75),(0,.88,0),"purple"),box((.72,.55,.06),(0,1.3,.4),"glass"),box((.75,.08,.35),(0,.92,.36),"black")], ["electronics","arcade","fun"],[1,1.8,.8])
furniture("sculpting_station",[box((1.3,.18,1.1),(0,.3,0),"stone"),cyl(.32,.85,(0,.82,0),"stone",12),box((.55,.65,.45),(0,1.55,0),"cream2")], ["hobby","sculpting","ambitions"],[1.4,2,1.2])
furniture("nectar_maker",[box((1.4,1.1,1.0),(0,.55,0),"wood"),cyl(.38,.72,(0,1.25,0),"darkwood",16),cyl(.08,.4,(.55,1.35,0),"metal",8)], ["world_adventures","nectar","crafting"],[1.5,1.8,1.1])
furniture("inventing_bench",[box((2.0,.8,1.0),(0,.4,0),"metal"),box((1.9,.10,.9),(0,.86,0),"darkwood"),cyl(.18,.7,(-.55,1.25,0),"orange",12),box((.55,.55,.3),(.5,1.15,0),"teal")], ["ambitions","inventing","crafting"],[2.1,1.7,1.1])


# Additional parity-facing Build/Buy and expansion objects.
furniture("mailbox_basic",[box((.65,.48,.42),(0,1.2,0),"cream2"),box((.55,.08,.38),(0,1.48,0),"roof"),cyl(.07,1.6,(0,.8,0),"metal",16),box((.08,.45,.06),(.34,1.42,0),"red")],["mail","bills","service"],[.8,1.8,.6])
furniture("trash_can",[cyl(.42,.9,(0,.45,0),"metal",24),cyl(.46,.10,(0,.94,0),"black",24),box((.40,.08,.08),(0,1.02,0),"metal")],["trash","clean"],[1,1.1,1])
furniture("dishwasher",[box((1.18,.92,1.0),(0,.46,0),"metal"),box((1.02,.68,.05),(0,.47,.52),"black")]+[knob((x,.84,.57)) for x in (-.28,0,.28)],["kitchen","clean","appliance"],[1.2,1,1.05])
furniture("microwave",screen_panel((1.0,.62,.58),(0,.72,0))+[box((.22,.48,.05),(.36,.72,.31),"black"),knob((.36,.82,.35))],["kitchen","cooking","appliance"],[1.05,1.05,.65])
furniture("coffee_maker",[box((.58,.75,.48),(0,.55,0),"black"),cyl(.20,.42,(0,.32,.25),"glass",20),box((.40,.08,.32),(0,.12,.18),"metal"),knob((.18,.72,.26),"red")],["kitchen","coffee","energy"],[.7,1,.7])
furniture("highchair",chair_parts("cream2")+[box((.78,.08,.48),(0,1.02,.24),"white"),cyl(.05,.45,(0,1.18,-.25),"metal",12)],["nursery","baby","family"],[.9,1.5,.9])
furniture("birthday_cake",[cyl(.46,.34,(0,.20,0),"cream2",28),cyl(.38,.16,(0,.45,0),"rose",28)]+[cyl(.025,.20,(x,.64,z),"yellow",10) for x,z in [(-.18,-.1),(0,.05),(.18,-.1)]],["family","birthday","food"],[1,.8,1])
furniture("garden_planter",[box((1.8,.42,1.2),(0,.22,0),"wood"),box((1.55,.22,.95),(0,.47,0),"darkwood")]+[sphere(.16,(x,.66,z),"green",2) for x in (-.5,0,.5) for z in (-.22,.22)],["garden","plant","outdoor"],[2,1,1.4])
furniture("fishing_sign",[box((.08,1.4,.08),(0,.7,0),"wood"),box((.85,.55,.08),(0,1.3,0),"blue"),cyl(.12,.06,(0,1.30,.08),"white",16)],["fishing","outdoor","water"],[1,1.8,.3])
furniture("gem_display",[box((1.35,.85,.72),(0,.43,0),"darkwood"),box((1.2,.58,.55),(0,1.0,0),"glass"),cone(.18,.35,(-.32,1.18,0),"purple",8),sphere(.18,(.28,1.12,0),"gold",2)],["collecting","gems","display"],[1.5,1.4,.8])
furniture("piano_upright",[box((1.65,1.35,.62),(0,.75,0),"darkwood"),box((1.42,.12,.50),(0,.67,.36),"wood")]+[box((.06,.04,.28),(-.62+i*.13,.76,.48),"white" if i%2==0 else "black") for i in range(10)],["music","piano","performance"],[1.8,1.5,.8])
furniture("drum_set",[cyl(.42,.55,(0,.5,0),"red",24),cyl(.28,.42,(-.65,.7,.05),"red",24),cyl(.28,.42,(.65,.7,.05),"red",24),cyl(.36,.05,(-.55,1.25,-.2),"gold",28),cyl(.36,.05,(.55,1.25,-.2),"gold",28)],["music","drums","performance"],[2.2,1.5,1.5])
furniture("mixology_bar",[box((2.5,1.0,.9),(0,.5,0),"darkwood"),box((2.7,.12,1.0),(0,1.07,0),"wood")]+[cyl(.08,.45,(x,1.36,.05),mat,14) for x,mat in [(-.7,"red"),(-.35,"green"),(0,"blue"),(.35,"gold"),(.7,"purple")]], ["bar","mixology","nightlife"],[2.8,1.7,1.2])
furniture("martial_arts_dummy",[cyl(.16,1.8,(0,.9,0),"wood",18),box((1.0,.10,.10),(0,1.25,0),"darkwood"),box((.75,.10,.10),(0,.75,0),"darkwood"),box((.7,.12,.7),(0,.08,0),"stone")],["martial_arts","training","world_adventures"],[1.2,2,1.2])
furniture("photo_booth",[box((1.4,2.0,1.25),(0,1,0),"purple"),box((.7,1.5,.04),(.36,1,.65),"glass"),box((.5,.35,.04),(-.36,1.5,.65),"black"),knob((-.36,1.1,.69),"gold")],["photography","social","nightlife"],[1.5,2.1,1.4])
furniture("tattoo_chair",[box((.75,.22,1.6),(0,.72,0),"black"),box((.75,.65,.20),(0,1.05,-.68),"black"),cyl(.13,.6,(0,.34,0),"metal",16),box((.8,.10,.8),(0,.05,0),"metal")],["tattoo","profession","ambitions"],[1.1,1.5,1.8])
furniture("treehouse",[box((2.2,1.8,2.0),(0,2.8,0),"wood"),box((2.5,.20,2.3),(0,3.8,0),"roof"),cyl(.45,3.8,(0,1.9,0),"darkwood",18)]+[box((.12,.18,.8),(-1.0+i*.25,.65,0),"wood") for i in range(9)],["children","tree_house","generations"],[3,4.2,2.8])
furniture("dog_bed",[cyl(.62,.20,(0,.12,0),"red",28),cyl(.46,.12,(0,.25,0),"cream2",28)],["pets","dog","comfort"],[1.4,.4,1.4])
furniture("cat_tree",[cyl(.08,1.5,(0,.75,0),"wood",16),box((.75,.12,.75),(0,1.45,0),"cream2"),box((.55,.60,.55),(.30,.65,0),"rose"),cyl(.12,.18,(-.25,1.58,.15),"green",16)],["pets","cat","fun"],[1.2,1.9,1.2])
furniture("horse_trough",[box((2.2,.65,.8),(0,.38,0),"wood"),box((1.85,.22,.52),(0,.67,0),"water")],["pets","horse","feeding"],[2.4,.9,1])
furniture("karaoke_machine",screen_panel((1.0,1.35,.45),(0,.95,0))+[cyl(.04,.85,(-.55,.75,.20),"metal",12),sphere(.10,(-.55,1.2,.20),"black",2)],["karaoke","music","showtime"],[1.4,1.8,.7])
furniture("bonfire",[cyl(.13,1.3,(-.25,.35,0),"wood",10),cyl(.13,1.3,(.25,.35,0),"wood",10),cone(.5,.9,(0,.72,0),"orange",12),cone(.28,.65,(0,.9,0),"yellow",12)],["outdoor","festival","fire"],[1.5,1.5,1.5])
furniture("festival_booth",[box((2.4,1.1,1.2),(0,.55,0),"teal"),box((2.8,.18,1.5),(0,1.3,0),"yellow"),box((2.4,1.3,.12),(0,1.9,-.5),"cream2")]+[cyl(.06,.5,(x,1.65,.58),"red",12) for x in (-.75,-.25,.25,.75)],["festival","seasonal","community"],[3,2.6,1.7])
furniture("university_podium",[box((1.1,1.15,.75),(0,.58,0),"wood"),box((1.3,.12,.9),(0,1.2,0),"darkwood"),box((.5,.28,.06),(0,1.42,.4),"gold")],["university","class","education"],[1.4,1.7,1])
furniture("diving_buoy",[sphere(.48,(0,.52,0),"orange",2),cyl(.05,1.0,(0,1.15,0),"metal",14),cone(.22,.35,(0,1.82,0),"red",12)],["island_paradise","diving","water"],[1.2,2.1,1.2])
furniture("time_portal",[cyl(.15,3.0,(-.85,1.5,0),"metal",18),cyl(.15,3.0,(.85,1.5,0),"metal",18),box((2.0,.25,.6),(0,2.9,0),"teal"),box((2.0,.25,.6),(0,.15,0),"teal"),sphere(.22,(0,1.5,0),"purple",2)],["future","portal","time_travel"],[2.5,3.2,1])
furniture("dream_pod",[box((1.35,.5,2.2),(0,.42,0),"white"),box((1.20,.48,1.7),(0,.72,.08),"teal"),box((1.25,.12,.45),(0,1.15,-.75),"glass")],["future","sleep","dream"],[1.5,1.4,2.4])
furniture("bot_charging_station",[box((1.2,.16,1.2),(0,.08,0),"metal"),cyl(.42,.12,(0,.22,0),"teal",20),box((.18,1.3,.18),(-.48,.75,-.45),"metal"),sphere(.09,(-.48,1.45,-.45),"gold",1)],["future","plumbot","charging"],[1.4,1.6,1.4])
furniture("resort_tower",[box((3.2,4.6,3.2),(0,2.3,0),"white"),box((3.5,.28,3.5),(0,4.75,0),"teal")]+[box((.55,.42,.05),(x,y,1.63),"glass") for x in (-.9,0,.9) for y in (1.0,2.0,3.0,4.0)],["resort","tower","island_paradise"],[4,5.2,4])
furniture("food_truck",[box((3.6,1.7,1.8),(0,1.05,0),"orange"),box((1.6,.8,.05),(.45,1.35,.93),"cream2")]+[cyl(.42,.24,(x,.42,z),"black",20) for x in (-1.15,1.15) for z in (-.82,.82)],["food","vehicle","community"],[4.2,2.2,2.1])

# Character silhouette variants for CAS and crowd visual replacement.
for stage, scale, yoff in [("child",.72,0.0),("teen",.90,0.0),("adult",1.0,0.0),("elder",.98,0.0)]:
    for shape_name, width in [("slender",.82),("average",1.0),("athletic",1.08),("soft",1.15)]:
        aid=f"sim_{stage}_{shape_name}"
        body_h=1.0*scale; leg_h=.82*scale
        parts=[box((.72*width*scale,body_h,.40*scale),(0,.9*scale+leg_h,0),"blue"),
               sphere(.30*scale,(0,1.98*scale,0),"skin",2),
               cyl(.10*scale,leg_h,(-.22*width*scale,.42*scale,0),"darkwood",18),
               cyl(.10*scale,leg_h,(.22*width*scale,.42*scale,0),"darkwood",18),
               cyl(.08*scale,.70*scale,(-.44*width*scale,1.35*scale,0),"skin",18),
               cyl(.08*scale,.70*scale,(.44*width*scale,1.35*scale,0),"skin",18),
               sphere(.31*scale,(0,2.15*scale,-.01),"darkwood",2)]
        assets.append(export_asset(aid,parts,"character",["sim","cas",stage,shape_name],[1.2*scale,2.4*scale,.8*scale]))

# Clean-room representative content slices for Stuff Packs and Showtime runtime.
furniture("luxury_lounge_chair",[box((1.05,.22,1.0),(0,.45,0),"purple"),box((1.0,.75,.18),(0,.88,-.38),"purple"),box((.18,.62,1.0),(-.45,.62,0),"gold"),box((.18,.62,1.0),(.45,.62,0),"gold")]+[cyl(.055,.28,(x,.14,z),"gold",10) for x in (-.36,.36) for z in (-.34,.34)],["stuff_pack","sp01","comfort"],[1.1,1.3,1.1])
furniture("sport_car_display",[box((3.5,.55,1.55),(0,.55,0),"red"),box((1.65,.55,1.42),(-.2,1.05,0),"glass"),box((.75,.18,1.65),(1.45,.62,0),"black")]+[cyl(.35,.24,(x,.34,z),"black",20) for x in (-1.15,1.15) for z in (-.76,.76)],["stuff_pack","sp02","vehicle"],[4.0,1.6,2.0])
furniture("community_locker",[box((1.05,1.95,.58),(0,.98,0),"metal")]+[box((.82,.035,.025),(0,.35+i*.46,.305),"black") for i in range(4)]+[knob((.34,.35+i*.46,.34),"gold") for i in range(4)],["stuff_pack","sp04","community"],[1.1,2.0,.65])
furniture("spa_vanity",[box((1.5,.12,.60),(0,.72,0),"cream2"),box((1.3,1.0,.08),(0,1.28,-.24),"white"),box((1.08,.78,.035),(0,1.30,-.19),"glass")]+[box((.12,.72,.12),(x,.36,z),"gold") for x in (-.6,.6) for z in (-.20,.20)],["stuff_pack","sp05","vanity"],[1.5,1.8,.7])
furniture("candy_floor_lamp",[cyl(.10,1.45,(0,.73,0),"white",18),sphere(.36,(0,1.58,0),"rose",2),sphere(.16,(0,1.91,0),"yellow",2),cyl(.38,.10,(0,.05,0),"teal",20)],["stuff_pack","sp06","lighting"],[.8,2.1,.8])
furniture("industrial_coffee_table",[box((1.75,.12,.88),(0,.55,0),"metal")]+[cyl(.07,.55,(x,.28,z),"black",10) for x in (-.7,.7) for z in (-.32,.32)]+[sphere(.055,(x,.62,z),"gold",1) for x in (-.7,.7) for z in (-.32,.32)],["stuff_pack","sp07","industrial"],[1.8,.75,.95])
furniture("retro_dance_console",[box((1.0,1.38,.68),(0,.69,0),"teal"),box((.78,.46,.05),(0,1.02,.37),"glass"),cyl(.17,.05,(-.22,.55,.38),"purple",18),cyl(.17,.05,(.22,.55,.38),"orange",18),box((.72,.08,.30),(0,.32,.40),"black")],["stuff_pack","sp08","retro","electronics"],[1.1,1.5,.8])
furniture("movie_prop_statue",[cyl(.46,.25,(0,.13,0),"stone",18),box((.72,.32,.55),(0,.44,0),"darkwood"),cyl(.18,1.0,(0,1.05,0),"gold",14),sphere(.28,(0,1.72,0),"gold",2),cone(.34,.65,(0,2.05,0),"purple",12)],["stuff_pack","sp09","cinema","decor"],[1.2,2.4,1.2])
furniture("performance_stage",[box((4.5,.32,3.5),(0,.16,0),"darkwood"),box((4.2,.14,3.2),(0,.39,0),"purple")]+[cyl(.08,2.7,(x,1.55,-1.45),"metal",12) for x in (-1.9,1.9)]+[box((.25,.25,.12),(x,2.65,-1.45),"gold") for x in (-1.9,0,1.9)]+[box((.05,2.3,.05),(x,1.45,z),"black") for x in (-2.0,2.0) for z in (-1.55,1.55)],["showtime","performance","stage"],[4.8,3.0,3.8])

# Vehicles and animals are not yet gameplay-integrated, but provide clean-room production-ready visual contracts.
assets.append(export_asset("vehicle_compact",[box((3.6,.8,1.65),(0,.65,0),"blue"),box((1.8,.75,1.55),(-.2,1.35,0),"glass")]+[cyl(.33,.22,(x,.35,z),"black",16) for x in (-1.15,1.15) for z in (-.78,.78)],"vehicle",["car","transport"],[4,2,2]))
assets.append(export_asset("pet_dog",[box((1.05,.65,.42),(0,.65,0),"wood"),sphere(.34,(.65,1.0,0),"wood",2),sphere(.09,(.94,1.0,.02),"black",2),cone(.12,.28,(.58,1.28,-.18),"darkwood",8),cone(.12,.28,(.58,1.28,.18),"darkwood",8),cyl(.09,.55,(-.35,.28,-.16),"darkwood",12),cyl(.09,.55,(.35,.28,-.16),"darkwood",12),cyl(.09,.55,(-.35,.28,.16),"darkwood",12),cyl(.09,.55,(.35,.28,.16),"darkwood",12),cyl(.07,.55,(-.62,.75,0),"wood",12)],"character",["pet","dog"],[1.5,1.5,.8]))
assets.append(export_asset("pet_cat",[box((.72,.5,.32),(0,.52,0),"stone"),sphere(.27,(.43,.85,0),"stone",2),cone(.12,.28,(.32,1.12,-.12),"stone",4),cone(.12,.28,(.32,1.12,.12),"stone",4)],"character",["pet","cat"],[1,1.3,.55]))
assets.append(export_asset("pet_horse",[box((1.65,1.12,.58),(0,1.28,0),"wood"),box((.48,.92,.44),(.98,1.74,0),"wood"),sphere(.28,(1.15,2.18,0),"wood",2),cone(.09,.22,(1.05,2.48,-.13),"darkwood",8),cone(.09,.22,(1.05,2.48,.13),"darkwood",8)]+[cyl(.10,1.28,(x,.64,z),"darkwood",12) for x in (-.58,.58) for z in (-.19,.19)]+[cyl(.06,.75,(-.98,1.35,0),"darkwood",12)],"character",["pet","horse"],[2.7,2.6,.9]))

# simple humanoid visual reference (not a rig; current playable Sim agent keeps runtime capsule fallback)
assets.append(export_asset("sim_avatar_reference",[cyl(.32,1.0,(0,1.25,0),"blue",10),sphere(.34,(0,1.98,0),"skin",2),cyl(.12,.9,(-.2,.45,0),"darkwood",8),cyl(.12,.9,(.2,.45,0),"darkwood",8),cyl(.10,.9,(-.42,1.35,0),"skin",8),cyl(.10,.9,(.42,1.35,0),"skin",8)],"character",["sim","reference","unrigged"],[1.1,2.35,.7]))

# --- audio ---------------------------------------------------------------
RATE=44100

def write_wav(name, duration, freqs, envelope="pluck", noise=0.0):
    n=max(1,int(RATE*duration)); t=np.arange(n,dtype=np.float64)/RATE
    sig=np.zeros(n)
    for f,amp in freqs: sig += amp*np.sin(2*np.pi*f*t)
    if noise: sig += np.random.default_rng(7).normal(0,noise,n)
    if envelope=="pluck": env=np.exp(-5*t/max(duration,1e-3))
    elif envelope=="soft": env=np.sin(np.pi*np.clip(t/duration,0,1))**1.5
    else: env=np.ones(n)
    sig*=env; peak=max(float(np.max(np.abs(sig))),1e-9); sig=np.clip(sig/peak*0.55,-1,1)
    pcm=(sig*32767).astype('<i2')
    p=AUDIO_DIR/f"{name}.wav"
    with wave.open(str(p),'wb') as w: w.setnchannels(1); w.setsampwidth(2); w.setframerate(RATE); w.writeframes(pcm.tobytes())
    return {"id":name,"path":f"res://assets/generated/audio/{p.name}","role":"sfx","sha256":hashlib.sha256(p.read_bytes()).hexdigest(),"bytes":p.stat().st_size,"duration_seconds":duration,"sample_rate":RATE}

audio=[
    write_wav("ui_click",.08,[(880,.8),(1320,.25)]),
    write_wav("ui_confirm",.20,[(523,.55),(659,.45),(784,.4)],"soft"),
    write_wav("ui_cancel",.18,[(330,.6),(220,.45)],"soft"),
    write_wav("ui_notification",.28,[(659,.45),(880,.5),(1046,.35)],"soft"),
    write_wav("ui_money",.30,[(784,.45),(988,.42),(1318,.35)],"pluck"),
    write_wav("build_place",.12,[(180,.7),(260,.25)],"pluck",noise=.03),
    write_wav("build_sell",.16,[(380,.5),(250,.35)],"pluck"),
    write_wav("save_complete",.34,[(440,.35),(660,.35),(880,.32)],"soft"),
    write_wav("load_complete",.34,[(392,.35),(587,.35),(784,.32)],"soft"),
    write_wav("event_birth",.55,[(523,.28),(659,.32),(784,.36),(1046,.24)],"soft"),
    write_wav("event_skill",.42,[(392,.25),(523,.32),(659,.38),(784,.25)],"soft"),
    write_wav("event_promotion",.70,[(392,.22),(523,.28),(659,.30),(784,.32),(1046,.18)],"soft"),
    write_wav("event_relationship",.34,[(587,.28),(740,.32),(880,.20)],"soft"),
    write_wav("object_water",.45,[(180,.18),(240,.10)],"soft",noise=.08),
    write_wav("object_cook",.48,[(110,.18),(165,.12)],"soft",noise=.12),
    write_wav("object_music",.42,[(440,.30),(554,.22),(659,.25)],"soft"),
    write_wav("object_computer",.18,[(1200,.25),(1600,.20)],"pluck"),
    write_wav("weather_thunder",1.10,[(62,.35),(91,.28)],"soft",noise=.20),
    write_wav("magic_cast",.62,[(740,.18),(880,.26),(1174,.24),(1480,.18)],"soft"),
    write_wav("festival_chime",.72,[(523,.20),(659,.25),(784,.24),(988,.18)],"soft"),
    write_wav("portal_open",.90,[(110,.25),(220,.15),(440,.12)],"soft",noise=.04),
]



def write_music_loop(name, duration, chord_roots, tempo=96.0):
    n=int(RATE*duration); t=np.arange(n,dtype=np.float64)/RATE; sig=np.zeros(n)
    beat=60.0/tempo
    for step,root in enumerate(chord_roots):
        start=(step*2*beat)%duration; end=min(duration,start+2*beat)
        mask=(t>=start)&(t<end); local=t[mask]-start
        chord=[root,root*1.25,root*1.5]
        tone=np.zeros(local.size)
        for f in chord:
            tone += .11*np.sin(2*np.pi*f*local)+.035*np.sin(2*np.pi*f*2*local)
        env=np.minimum(1.0,local/.08)*np.minimum(1.0,(end-start-local)/.22)
        sig[mask]+=tone*np.clip(env,0,1)
    # quiet rhythmic pulse
    for k in range(int(duration/beat)):
        start=k*beat; mask=(t>=start)&(t<min(duration,start+.15)); local=t[mask]-start
        sig[mask]+=.035*np.sin(2*np.pi*110*local)*np.exp(-18*local)
    peak=max(float(np.max(np.abs(sig))),1e-9); sig=np.clip(sig/peak*.38,-1,1)
    pcm=(sig*32767).astype('<i2'); path=AUDIO_DIR/f"{name}.wav"
    with wave.open(str(path),'wb') as w: w.setnchannels(1); w.setsampwidth(2); w.setframerate(RATE); w.writeframes(pcm.tobytes())
    return {"id":name,"path":f"res://assets/generated/audio/{path.name}","role":"music","sha256":hashlib.sha256(path.read_bytes()).hexdigest(),"bytes":path.stat().st_size,"duration_seconds":duration,"sample_rate":RATE}

audio += [
    write_music_loop("music_live_loop",12.0,[220.0,246.94,196.0,220.0],92.0),
    write_music_loop("music_build_loop",12.0,[261.63,293.66,329.63,246.94],104.0),
    write_music_loop("music_cas_loop",12.0,[196.0,220.0,246.94,293.66],84.0),
]

# --- procedural textures -------------------------------------------------
def save_texture(name, base, accent, pattern):
    size=256
    img=Image.new("RGB",(size,size),rgba(base)[:3]); draw=ImageDraw.Draw(img)
    if pattern=="grass":
        rng=np.random.default_rng(1904)
        for _ in range(2600):
            x=int(rng.integers(0,size)); y=int(rng.integers(0,size)); v=int(rng.integers(-18,19))
            c=tuple(max(0,min(255,ch+v)) for ch in rgba(accent)[:3]); draw.point((x,y),fill=c)
    elif pattern=="wood":
        for y in range(0,size,24): draw.rectangle((0,y,size,y+3),fill=rgba(accent)[:3])
        for x in range(0,size,64): draw.line((x,0,x,size),fill=rgba(accent)[:3],width=2)
    elif pattern=="tile":
        for x in range(0,size,32): draw.line((x,0,x,size),fill=rgba(accent)[:3],width=2)
        for y in range(0,size,32): draw.line((0,y,size,y),fill=rgba(accent)[:3],width=2)
    elif pattern=="road":
        rng=np.random.default_rng(311)
        for _ in range(1500):
            x=int(rng.integers(0,size)); y=int(rng.integers(0,size)); draw.point((x,y),fill=rgba(accent)[:3])
    elif pattern=="wallpaper":
        for x in range(16,size,48):
            for y in range(16,size,48): draw.ellipse((x-3,y-3,x+3,y+3),fill=rgba(accent)[:3])
    elif pattern=="stone":
        for y in range(0,size,42):
            off=21 if (y//42)%2 else 0
            for x in range(-off,size,56): draw.rectangle((x,y,x+52,y+38),outline=rgba(accent)[:3],width=3)
    path=TEXTURE_DIR/f"{name}.png"; img.save(path,optimize=True)
    return {"id":name,"path":f"res://assets/generated/textures/{path.name}","sha256":hashlib.sha256(path.read_bytes()).hexdigest(),"bytes":path.stat().st_size,"size":[size,size]}

textures=[
    save_texture("terrain_grass","#6f8f5c","#5a7a4a","grass"),
    save_texture("terrain_road","#4a4f56","#3c4046","road"),
    save_texture("floor_wood","#8f6c4f","#674a34","wood"),
    save_texture("floor_tile","#d8d4ca","#aaa69f","tile"),
    save_texture("wallpaper_cream","#e6d9bd","#c9ad7f","wallpaper"),
    save_texture("wallpaper_blue","#afc8d6","#789eb1","wallpaper"),
    save_texture("stone_paver","#97938a","#706d67","stone"),
]

# --- UI vector icons ------------------------------------------------------
icons={
    "mode_live":"M12 2 L21 12 L17 12 L17 21 L7 21 L7 12 L3 12 Z",
    "mode_build":"M3 18 L14 7 L17 10 L6 21 Z M13 4 L16 1 L23 8 L20 11 Z",
    "mode_cas":"M12 3 A4 4 0 1 0 12 11 A4 4 0 1 0 12 3 M4 21 C5 15 19 15 20 21 Z",
    "save":"M4 3 H18 L21 6 V21 H3 V3 Z M7 3 V9 H17 V3 M7 14 H17 V20 H7 Z",
    "map":"M3 5 L9 2 L15 5 L21 2 V19 L15 22 L9 19 L3 22 Z M9 2 V19 M15 5 V22",
}
for name,pathd in icons.items():
    p=UI_DIR/f"{name}.svg"; p.write_text(f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="{pathd}" fill="none" stroke="#edf5f4" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>''')

manifest={
    "schema_version":1,
    "generator":"tools/generate_assets.py",
    "license":"Project-owned original procedural assets; see LICENSE",
    "models":assets,
    "audio":audio,
    "textures":textures,
    "ui":[{"id":p.stem,"path":f"res://assets/generated/ui/{p.name}","sha256":hashlib.sha256(p.read_bytes()).hexdigest(),"bytes":p.stat().st_size} for p in sorted(UI_DIR.glob('*.svg'))],
}
(OUT/"manifest.json").write_text(json.dumps(manifest,indent=2)+"\n")

aliases={}
for r in assets+audio+textures+manifest['ui']: aliases[r['id']]=r['path']
(ROOT/"data"/"asset_aliases.json").write_text(json.dumps(aliases,indent=2,sort_keys=True)+"\n")
print(f"Generated {len(assets)} GLB models, {len(audio)} WAV SFX, {len(textures)} PNG textures, {len(manifest['ui'])} SVG UI icons")
print(f"Manifest: {OUT/'manifest.json'}")
