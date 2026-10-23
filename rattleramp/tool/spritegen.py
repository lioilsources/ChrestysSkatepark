#!/usr/bin/env python3
"""RattleRamp avatar sprites: FLUX.1-schnell (NIM :8030) -> BiRefNet-general (ComfyUI) -> trimmed RGBA PNG.

  python3 tool/spritegen.py gen  OUT [name ...]   # raw JPGs, N seeds each (NIM, no ComfyUI needed)
  python3 tool/spritegen.py cut  OUT name=seed[:m] ...  # cut chosen heads into assets/sprites/heads/ (m = mirror)
  python3 tool/spritegen.py deck OUT name=seed ...  # crop chosen raw deck graphics into assets/sprites/decks/

ComfyUI rules on the Spark: one job at a time, check /queue first, POST /free when done.
"""
import base64, io, json, sys, time, urllib.request, uuid
from pathlib import Path

from PIL import Image

HOST = "spark-99bb"
# The NIM listens on the Spark's localhost only: ssh -f -N -L 18030:localhost:8030 spark-99bb
NIM = "http://localhost:18030/v1/infer"
COMFY = f"http://{HOST}:8188"
SEEDS = [11, 23, 37]
ASSETS = Path(__file__).resolve().parent.parent / "assets" / "sprites"

HEAD = ("cute flat vector sticker illustration, {subj}, head and neck only, strict side profile view facing right, "
        "single character centered, thick dark outline, bold saturated colors, simple rounded shapes, minimal shading, "
        "white sticker border, plain light grey background, no text, no letters, no body")
DECK = ("flat vector skateboard deck graphic, {subj}, wide horizontal banner composition filling the whole frame "
        "edge to edge, bold saturated colors, thick dark outlines, no skateboard shape, no wheels, no text, no letters")

HEADS = {
    "punk": "a teenage skater boy with a tall green mohawk and a silver nose ring, grinning",
    "beanie": "a skater girl with a long blond ponytail wearing a red knitted beanie, smiling",
    "dreads": "a young dark-skinned skater man with long dreadlocks and a yellow headband, cool smile",
    "helmet": "a skater girl with a short pink bob haircut wearing a light blue skate helmet, determined look",
    "oldschool": "a bearded old school skater man wearing a backwards red baseball cap, laughing",
    "kid": "a small freckled kid with ginger hair wearing an orange skate helmet, excited open mouth",
    "afro": "a brown-skinned skater girl with two big afro puffs and big round sunglasses, cheeky smile",
    "chrestys": "a cool cartoon rattlesnake head with green scales and yellow eyes wearing a backwards black baseball cap, "
                "forked red tongue sticking out, smirking mascot",
}
DECKS = {
    "flames": "orange and yellow hot rod flames on black",
    "snake": "a long green rattlesnake stretched along the length with diamond pattern scales on purple",
    "checker": "black and white checkerboard with a pink lightning bolt",
    "galaxy": "deep blue space galaxy with stars and a ringed planet",
    "waves": "japanese style big blue ocean waves with white foam",
    "pizza": "pepperoni pizza slices scattered on bright red",
}


def post(url, body):
    req = urllib.request.Request(url, json.dumps(body).encode(), {"Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=300))


def flux(prompt, seed, w=1024, h=1024):
    r = post(NIM, {"prompt": prompt, "width": w, "height": h, "steps": 4, "seed": seed})
    return Image.open(io.BytesIO(base64.b64decode(r["artifacts"][0]["base64"]))).convert("RGB")


def queue_empty():
    q = json.load(urllib.request.urlopen(f"{COMFY}/queue", timeout=10))
    return not q["queue_running"] and not q["queue_pending"]


def birefnet(img, name):
    buf = io.BytesIO()
    img.save(buf, "PNG")
    bnd = uuid.uuid4().hex
    body = (f"--{bnd}\r\nContent-Disposition: form-data; name=\"image\"; filename=\"rr_{name}.png\"\r\n"
            f"Content-Type: image/png\r\n\r\n").encode() + buf.getvalue() + \
        f"\r\n--{bnd}\r\nContent-Disposition: form-data; name=\"overwrite\"\r\n\r\ntrue\r\n--{bnd}--\r\n".encode()
    up = json.load(urllib.request.urlopen(urllib.request.Request(
        f"{COMFY}/upload/image", body, {"Content-Type": f"multipart/form-data; boundary={bnd}"})))
    g = {"1": {"class_type": "LoadImage", "inputs": {"image": up["name"]}},
         "2": {"class_type": "BiRefNetRMBG", "inputs": {
             "image": ["1", 0], "model": "BiRefNet-general", "mask_blur": 0, "mask_offset": 0,
             "invert_output": False, "refine_foreground": True, "background": "Alpha",
             "background_color": "#222222"}},
         "3": {"class_type": "SaveImage", "inputs": {"images": ["2", 0], "filename_prefix": f"rattleramp/{name}"}}}
    pid = post(f"{COMFY}/prompt", {"prompt": g})["prompt_id"]
    while True:
        h = json.load(urllib.request.urlopen(f"{COMFY}/history/{pid}"))
        if pid in h and (h[pid].get("outputs") or h[pid].get("status", {}).get("completed") is not None):
            break
        time.sleep(1)
    if h[pid].get("status", {}).get("status_str") == "error":
        raise RuntimeError(json.dumps(h[pid]["status"])[:800])
    o = h[pid]["outputs"]["3"]["images"][0]
    q = f"filename={o['filename']}&subfolder={o['subfolder']}&type={o['type']}"
    return Image.open(io.BytesIO(urllib.request.urlopen(f"{COMFY}/view?{q}").read())).convert("RGBA")


def trim(rgba, size=256):
    box = rgba.getchannel("A").point(lambda a: 255 if a > 16 else 0).getbbox()
    obj = rgba.crop(box)
    s = size / max(obj.size)
    return obj.resize((max(1, round(obj.width * s)), max(1, round(obj.height * s))), Image.LANCZOS)


def gen(out, names):
    out.mkdir(parents=True, exist_ok=True)
    jobs = [(n, HEAD.format(subj=HEADS[n]), 1024, 1024) for n in HEADS if not names or n in names]
    jobs += [(f"deck_{n}", DECK.format(subj=DECKS[n]), 1344, 768) for n in DECKS if not names or f"deck_{n}" in names]
    for name, prompt, w, h in jobs:
        for seed in SEEDS:
            path = out / f"{name}_s{seed}.jpg"
            if path.exists():
                continue
            t = time.time()
            flux(prompt, seed, w, h).save(path, quality=92)
            print(f"{path.name}: {time.time() - t:.1f} s", flush=True)


def cut(out, picks):
    if not queue_empty():
        sys.exit("ComfyUI queue is busy — try again in a moment")
    dest = ASSETS / "heads"
    dest.mkdir(parents=True, exist_ok=True)
    for pick in picks:
        # name=seed, or name=seed:m to mirror — heads are stored facing LEFT.
        name, seed = pick.split("=")
        seed, _, flag = seed.partition(":")
        img = trim(birefnet(Image.open(out / f"{name}_s{seed}.jpg"), name))
        if flag == "m":
            img = img.transpose(Image.FLIP_LEFT_RIGHT)
        img.save(dest / f"{name}.png")
        print(f"heads/{name}.png", flush=True)
    # /free answers with an empty body.
    urllib.request.urlopen(urllib.request.Request(
        f"{COMFY}/free", json.dumps({"unload_models": True, "free_memory": True}).encode(),
        {"Content-Type": "application/json"}), timeout=30)


def deck(out, picks):
    dest = ASSETS / "decks"
    dest.mkdir(parents=True, exist_ok=True)
    for pick in picks:
        name, seed = pick.split("=")
        # The NIM's smallest height is 768, so cut a 4:1 strip from the middle.
        img = Image.open(out / f"deck_{name}_s{seed}.jpg")
        strip = img.crop((0, (img.height - img.width // 4) // 2, img.width, (img.height + img.width // 4) // 2))
        strip.resize((512, 128), Image.LANCZOS).save(dest / f"{name}.png")
        print(f"decks/{name}.png", flush=True)


if __name__ == "__main__":
    cmd, out, rest = sys.argv[1], Path(sys.argv[2]), sys.argv[3:]
    {"gen": gen, "cut": cut, "deck": deck}[cmd](out, rest)
