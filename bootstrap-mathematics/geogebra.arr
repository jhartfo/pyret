use context starter2024

# geo-lite.arr
#
# A small GeoGebra-style dynamic geometry prototype, in pure Pyret.
# Built only from Pyret's image library and reactors - no JavaScript.
#
# HOW TO RUN
#   1. Run this file in code.pyret.org (or the Pyret CLI).
#   2. In the interactions pane, type:   geo-applet()
#      (or  geo-applet-with(my-functions)  - see FnSpec below)
#
# WHAT YOU CAN DO
#   Toolbar (click a button, or press its key):
#     v Move       drag a free point; drag the background to pan
#     p Point      click to place a free point
#     m Midpoint   click two points
#     l Line       click two points (clicking empty space makes a point)
#     s Segment    click two points (clicking empty space makes a point)
#     c Circle     click the center, then a point on the circle
#     i Intersect  click two curves (lines/segments/circles)
#     g Polygon    click vertices in order; click the first vertex again to close
#     x Delete     click an object (everything built from it goes too)
#   Other keys:
#     z undo | f add the next preset function | n toggle snap to grid
#     + / - zoom | arrow keys pan | 0 reset view | escape cancel
#
# THE IDEA
#   The state holds only the *construction*: an ordered list of objects,
#   where each one is either a free point (with coordinates) or is defined
#   in terms of earlier objects ey name ("the line through A and B",
#   "the 2nd intersection of l1 and c1", ...).  Every redraw re-evaluates
#   the whole list, so dragging a free point automatically moves
#   everything that depends on it - the core trick of dynamic geometry.
#
# DESIGN NOTES
#   * Everything is drawn in screen coordinates (origin top-left), which
#     is also what the reactor's mouse events use, so no flipping needed.
#   * All geometry is done in roughnums: dragging produces arbitrary
#     decimals, and exact rationals would just grow without benefit.
#     Numbers are never compared with == (roughnums raise on that);
#     only <, > and tolerances are used.
#   * Functions typed in ey users can raise errors (1/0), so every
#     function evaluation goes through run-task and a failure simply
#     leaves a gap in the curve instead of crashing the applet.

include image
#include image-structs
include reactors
include either
import color as C

provide *
provide-types *

color = C.color

# =======================================================================
# CONSTANTS
# =======================================================================

W = 820
H = 580
TB-H = 34            # toolbar height in pixels
BTN-W = 90           # toolbar button width
STATUS-H = 44        # height of the status bar at the bottom
MIN-SCALE = 8        # pixels per world unit, zoomed out as far as allowed
MAX-SCALE = 400
PICK-PT-PX = 11      # how close (pixels) a click must be to grab a point
PICK-OBJ-PX = 7      # ... or to select a line / circle / curve
SNAP-STEP = 1/2
CIRCLE-SEGS = 120    # circles are drawn as polygons with this many sides
FN-STEP-PX = 3       # function curves are sampled every 3 pixels
EPS = 0.000000001
TOL = 0.000001
LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

C-GRID = "light-gray"
C-AXIS = "dim-gray"
C-FREE = "dodger-blue"
C-DERIVED = "dim-gray"
C-LINE = "black"
C-CIRCLE = "forest-green"
C-FN = "purple"
C-POLY = "midnight-blue"
C-HOT = "dark-orange"
C-PICKED = "crimson"

# =======================================================================
# DATA
# =======================================================================

# One entry of the construction. Every variant has a `name`.
data Obj:
  | free-pt(name :: String, x :: Number, y :: Number)
  | mid-pt(name :: String, a :: String, b :: String)
  | line-obj(name :: String, a :: String, b :: String)
  | seg-obj(name :: String, a :: String, b :: String)
  | circ-obj(name :: String, center :: String, thru :: String)
  | meet-pt(name :: String, o1 :: String, o2 :: String, which :: Number)
  | poly-obj(name :: String, verts :: List<String>)   # closed polygon through existing points, in order
  | fn-obj(name :: String, label :: String, f :: (Number -> Number))
end

# What an Obj evaluates to right now.
data Geo:
  | g-pt(x :: Number, y :: Number)
  | g-line(x1 :: Number, y1 :: Number, x2 :: Number, y2 :: Number, bounded :: Boolean)
  | g-circ(cx :: Number, cy :: Number, r :: Number)
  | g-fn(f :: (Number -> Number))
  | g-poly(pts :: List<Geo>)       # the vertices, each a g-pt
  | g-none
end

data Res:
  | res(name :: String, obj :: Obj, geo :: Geo)
end

# center of the window in world coordinates, and pixels per world unit
data View:
  | view(cx :: Number, cy :: Number, ppu :: Number)
end

data Drag:
  | d-none
  | d-pt(name :: String, start :: List<Obj>)
  | d-pan(px :: Number, py :: Number)
end

# A preset curve the user can add with the "f" key.
data FnSpec:
  | fn-spec(label :: String, f :: (Number -> Number))
end

data Tool:
  | tool(mode :: String, key :: String, label :: String)
end

data State:
  | st(objs :: List<Obj>,
       hist :: List<List<Obj>>,     # older constructions, for undo
       view :: View,
       mode :: String,
       picked :: List<String>,      # clicks collected so far ey the current tool
       drag :: Drag,
       npts :: Number,              # counters used to name new objects
       nobjs :: Number,
       hover :: String,             # name of the object under the mouse ("" if none)
       mpx :: Number,               # last mouse position, in pixels
       mpy :: Number,
       snap :: Boolean,
       fns :: List<FnSpec>,
       nfn :: Number,
       msg :: String)
end

data PM:
  | pm(s, name :: String)
end

data Cand:
  | cand(name :: String, d :: Number)
end

data Clip:
  | clip(x1 :: Number, y1 :: Number, x2 :: Number, y2 :: Number)
  | no-clip
end

data TRange:
  | trange(t0 :: Number, t1 :: Number, ok :: Boolean)
end

data Last:
  | no-last
  | last-at(sx :: Number, sy :: Number)
end

data Acc:
  | acc(scene :: Image, last :: Last)
end

data SPt:
  | spt(sx :: Number, sy :: Number)
end

TOOLS = [list:
  tool("move", "v", "Move"),
  tool("point", "p", "Point"),
  tool("midpoint", "m", "Midpoint"),
  tool("line", "l", "Line"),
  tool("segment", "s", "Segment"),
  tool("circle", "c", "Circle"),
  tool("intersect", "i", "Intersect"),
  tool("polygon", "g", "Polygon"),
  tool("delete", "x", "Delete")
]

DEFAULT-FNS = [list:
  fn-spec("sin(x)", lam(x): num-sin(x) end),
  fn-spec("x^2 / 4", lam(x): (x * x) / 4 end),
  fn-spec("x^3 / 8 - x", lam(x): (((x * x) * x) / 8) - x end),
  fn-spec("2 cos(x)", lam(x): 2 * num-cos(x) end),
  fn-spec("1 / x", lam(x): 1 / x end)
]

# =======================================================================
# PART 1: plain geometry (all in world coordinates)
# =======================================================================

fun hypot(dx :: Number, dy :: Number) -> Number:
  num-sqrt((dx * dx) + (dy * dy))
where:
  hypot(3, 4) is%(within-abs(0.000001)) 5
end

fun dist-point-line(px :: Number, py :: Number,
                    x1 :: Number, y1 :: Number, x2 :: Number, y2 :: Number) -> Number:
  doc: "Distance from (px,py) to the infinite line through (x1,y1),(x2,y2)"
  dx = x2 - x1
  dy = y2 - y1
  len = hypot(dx, dy)
  if len < EPS:
    hypot(px - x1, py - y1)
  else:
    num-abs(((px - x1) * dy) - ((py - y1) * dx)) / len
  end
where:
  dist-point-line(7, 3, 0, 0, 4, 0) is%(within-abs(0.000001)) 3
end

fun dist-point-segment(px :: Number, py :: Number,
                       x1 :: Number, y1 :: Number, x2 :: Number, y2 :: Number) -> Number:
  doc: "Distance from (px,py) to the segment from (x1,y1) to (x2,y2)"
  dx = x2 - x1
  dy = y2 - y1
  len2 = (dx * dx) + (dy * dy)
  if len2 < EPS:
    hypot(px - x1, py - y1)
  else:
    t = num-max(0, num-min(1, (((px - x1) * dx) + ((py - y1) * dy)) / len2))
    hypot(px - (x1 + (t * dx)), py - (y1 + (t * dy)))
  end
where:
  dist-point-segment(2, 2, 0, 0, 4, 0) is%(within-abs(0.000001)) 2
  dist-point-segment(7, 3, 0, 0, 4, 0) is%(within-abs(0.000001)) 4.242640687119285
end

fun in-range(t :: Number, bounded :: Boolean) -> Boolean:
  doc: "A line parameter t is acceptable for a segment (bounded) only if it lies in [0,1]"
  (not(bounded)) or ((t >= (0 - TOL)) and (t <= (1 + TOL)))
end

fun meet-ll(g1 :: Geo, g2 :: Geo) -> List<Geo>:
  doc: "Intersection of two lines/segments, as a list of exactly two Geos (second is always g-none)"
  dx1 = g1.x2 - g1.x1
  dy1 = g1.y2 - g1.y1
  dx2 = g2.x2 - g2.x1
  dy2 = g2.y2 - g2.y1
  den = (dx1 * dy2) - (dy1 * dx2)
  if num-abs(den) < EPS:
    [list: g-none, g-none]
  else:
    ex = g2.x1 - g1.x1
    ey = g2.y1 - g1.y1
    t = ((ex * dy2) - (ey * dx2)) / den
    u = ((ex * dy1) - (ey * dx1)) / den
    if in-range(t, g1.bounded) and in-range(u, g2.bounded):
      [list: g-pt(g1.x1 + (t * dx1), g1.y1 + (t * dy1)), g-none]
    else:
      [list: g-none, g-none]
    end
  end
where:
  r1 = meet-ll(g-line(0, 0, 1, 1, false), g-line(0, 2, 2, 0, false))
  r1.get(0).x is%(within-abs(0.000001)) 1
  r1.get(0).y is%(within-abs(0.000001)) 1
  is-g-none(r1.get(1)) is true
  # parallel lines never meet
  is-g-none(meet-ll(g-line(0, 0, 1, 0, false), g-line(0, 1, 1, 1, false)).get(0)) is true
  # the same crossing, but one of the two is a segment that stops short of it
  is-g-none(meet-ll(g-line(0, 0, 0.5, 0.5, true), g-line(0, 2, 2, 0, false)).get(0)) is true
  is-g-pt(meet-ll(g-line(0, 0, 2, 2, true), g-line(0, 2, 2, 0, true)).get(0)) is true
end

fun meet-lc(gl :: Geo, gc :: Geo) -> List<Geo>:
  doc: "Intersections of a line/segment with a circle, ordered ey position along the line; always two entries"
  dx = gl.x2 - gl.x1
  dy = gl.y2 - gl.y1
  fx = gl.x1 - gc.cx
  fy = gl.y1 - gc.cy
  qa = (dx * dx) + (dy * dy)
  qb = 2 * ((fx * dx) + (fy * dy))
  qc = ((fx * fx) + (fy * fy)) - (gc.r * gc.r)
  disc = (qb * qb) - (4 * qa * qc)
  if (qa < EPS) or (disc < 0):
    [list: g-none, g-none]
  else:
    s = num-sqrt(disc)
    t1 = (0 - qb - s) / (2 * qa)
    t2 = ((0 - qb) + s) / (2 * qa)
    mk = lam(t):
      if in-range(t, gl.bounded):
        g-pt(gl.x1 + (t * dx), gl.y1 + (t * dy))
      else:
        g-none
      end
    end
    [list: mk(t1), mk(t2)]
  end
where:
  r1 = meet-lc(g-line(-5, 0, 5, 0, false), g-circ(0, 0, 3))
  r1.get(0).x is%(within-abs(0.000001)) -3
  r1.get(1).x is%(within-abs(0.000001)) 3
  r1.get(0).y is%(within-abs(0.000001)) 0
  # a line that misses the circle entirely
  is-g-none(meet-lc(g-line(-5, 5, 5, 5, false), g-circ(0, 0, 3)).get(0)) is true
  # a segment covering only the right half: just the second hit survives
  r2 = meet-lc(g-line(0, 0, 5, 0, true), g-circ(0, 0, 3))
  is-g-none(r2.get(0)) is true
  r2.get(1).x is%(within-abs(0.000001)) 3
end

fun meet-cc(c1 :: Geo, c2 :: Geo) -> List<Geo>:
  doc: "Intersections of two circles; always two entries"
  dx = c2.cx - c1.cx
  dy = c2.cy - c1.cy
  d = hypot(dx, dy)
  if (d < EPS) or (d > (c1.r + c2.r)) or (d < num-abs(c1.r - c2.r)):
    [list: g-none, g-none]
  else:
    a = (((c1.r * c1.r) - (c2.r * c2.r)) + (d * d)) / (2 * d)
    h = num-sqrt(num-max((c1.r * c1.r) - (a * a), 0))
    ux = dx / d
    uy = dy / d
    mx = c1.cx + (a * ux)
    my = c1.cy + (a * uy)
    [list: g-pt(mx - (h * uy), my + (h * ux)), g-pt(mx + (h * uy), my - (h * ux))]
  end
where:
  r1 = meet-cc(g-circ(0, 0, 5), g-circ(6, 0, 5))
  r1.get(0).x is%(within-abs(0.000001)) 3
  r1.get(0).y is%(within-abs(0.000001)) 4
  r1.get(1).y is%(within-abs(0.000001)) -4
  is-g-none(meet-cc(g-circ(0, 0, 1), g-circ(5, 0, 1)).get(0)) is true
end

fun poly-area(pts :: List<Geo>) -> Number:
  doc: "Area by the shoelace formula (pts are g-pt vertices in order; the sign of orientation is ignored)"
  n = pts.length()
  twice = fold(lam(sum, i):
    a = pts.get(i)
    b = pts.get(num-modulo(i + 1, n))
    sum + ((a.x * b.y) - (b.x * a.y))
  end, 0, range(0, n))
  num-abs(twice) / 2
where:
  poly-area([list: g-pt(0, 0), g-pt(1, 0), g-pt(1, 1), g-pt(0, 1)]) is%(within-abs(0.000001)) 1
  poly-area([list: g-pt(0, 0), g-pt(4, 0), g-pt(0, 3)]) is%(within-abs(0.000001)) 6
  # clockwise order gives the same area
  poly-area([list: g-pt(0, 3), g-pt(4, 0), g-pt(0, 0)]) is%(within-abs(0.000001)) 6
end

fun meet(g1 :: Geo, g2 :: Geo) -> List<Geo>:
  doc: "Intersections of two geometric objects (lines, segments, circles); function curves are not supported"
  none2 = [list: g-none, g-none]
  cases (Geo) g1:
    | g-line(_, _, _, _, _) =>
      cases (Geo) g2:
        | g-line(_, _, _, _, _) => meet-ll(g1, g2)
        | g-circ(_, _, _) => meet-lc(g1, g2)
        | else => none2
      end
    | g-circ(_, _, _) =>
      cases (Geo) g2:
        | g-line(_, _, _, _, _) => meet-lc(g2, g1)
        | g-circ(_, _, _) => meet-cc(g1, g2)
        | else => none2
      end
    | else => none2
  end
end

# Liang-Barsky clipping of a line (or segment) against the view rectangle.
fun clip-constrain(r :: TRange, p :: Number, q :: Number) -> TRange:
  if not(r.ok):
    r
  else if num-abs(p) < EPS:
    if q < 0:
      trange(r.t0, r.t1, false)
    else:
      r
    end
  else:
    t = q / p
    if p < 0:
      trange(num-max(r.t0, t), r.t1, true)
    else:
      trange(r.t0, num-min(r.t1, t), true)
    end
  end
end

fun clip-line(l :: Geo, xmin :: Number, xmax :: Number,
              ymin :: Number, ymax :: Number) -> Clip:
  doc: "The part of the line (or segment, if bounded) inside the rectangle, if any"
  dx = l.x2 - l.x1
  dy = l.y2 - l.y1
  if hypot(dx, dy) < EPS:
    no-clip
  else:
    r0 = if l.bounded: trange(0, 1, true) else: trange(~-1e12, ~1e12, true) end
    r1 = clip-constrain(r0, 0 - dx, l.x1 - xmin)
    r2 = clip-constrain(r1, dx, xmax - l.x1)
    r3 = clip-constrain(r2, 0 - dy, l.y1 - ymin)
    r4 = clip-constrain(r3, dy, ymax - l.y1)
    if r4.ok and (r4.t0 <= r4.t1):
      clip(l.x1 + (r4.t0 * dx), l.y1 + (r4.t0 * dy), l.x1 + (r4.t1 * dx), l.y1 + (r4.t1 * dy))
    else:
      no-clip
    end
  end
where:
  c1 = clip-line(g-line(0, 0, 1, 1, false), -10, 10, -6, 6)
  c1.x1 is%(within-abs(0.000001)) -6
  c1.y1 is%(within-abs(0.000001)) -6
  c1.x2 is%(within-abs(0.000001)) 6
  c1.y2 is%(within-abs(0.000001)) 6
  # a horizontal line entirely above the window
  clip-line(g-line(0, 9, 1, 9, false), -10, 10, -6, 6) is no-clip
  # a segment is cut to its own ends, not extended to the window edge
  c2 = clip-line(g-line(0, 0, 1, 1, true), -10, 10, -6, 6)
  c2.x2 is%(within-abs(0.000001)) 1
end

# =======================================================================
# PART 2: evaluating the construction
# =======================================================================

fun geo-of(rs :: List<Res>, name :: String) -> Geo:
  cases (Option) rs.find(lam(r): r.name == name end):
    | some(r) => r.geo
    | none => g-none
  end
end

fun two-pt-geo(rs :: List<Res>, a :: String, b :: String, bounded :: Boolean) -> Geo:
  ga = geo-of(rs, a)
  gb = geo-of(rs, b)
  if is-g-pt(ga) and is-g-pt(gb):
    g-line(ga.x, ga.y, gb.x, gb.y, bounded)
  else:
    g-none
  end
end

fun eval-obj(o :: Obj, rs :: List<Res>) -> Geo:
  doc: "Evaluates one object, given the already-evaluated objects before it"
  cases (Obj) o:
    | free-pt(_, x, y) => g-pt(x, y)
    | mid-pt(_, a, b) =>
      ga = geo-of(rs, a)
      gb = geo-of(rs, b)
      if is-g-pt(ga) and is-g-pt(gb):
        g-pt((ga.x + gb.x) / 2, (ga.y + gb.y) / 2)
      else:
        g-none
      end
    | line-obj(_, a, b) => two-pt-geo(rs, a, b, false)
    | seg-obj(_, a, b) => two-pt-geo(rs, a, b, true)
    | circ-obj(_, c, t) =>
      gc = geo-of(rs, c)
      gt = geo-of(rs, t)
      if is-g-pt(gc) and is-g-pt(gt):
        g-circ(gc.x, gc.y, hypot(gt.x - gc.x, gt.y - gc.y))
      else:
        g-none
      end
    | meet-pt(_, o1, o2, which) =>
      meet(geo-of(rs, o1), geo-of(rs, o2)).get(which)
    | poly-obj(_, vs) =>
      gs = vs.map(lam(v): geo-of(rs, v) end)
      if gs.all(is-g-pt) and (gs.length() >= 3):
        g-poly(gs)
      else:
        g-none
      end
    | fn-obj(_, _, f) => g-fn(f)
  end
end

fun build-geo(objs :: List<Obj>) -> List<Res>:
  doc: "Evaluates the whole construction in order, so each object can use the ones before it"
  fold(lam(done, o): done + [list: res(o.name, o, eval-obj(o, done))] end, empty, objs)
end

fun refs(o :: Obj) -> List<String>:
  doc: "The names of the objects that o is built from"
  cases (Obj) o:
    | free-pt(_, _, _) => empty
    | mid-pt(_, a, b) => [list: a, b]
    | line-obj(_, a, b) => [list: a, b]
    | seg-obj(_, a, b) => [list: a, b]
    | circ-obj(_, c, t) => [list: c, t]
    | meet-pt(_, o1, o2, _) => [list: o1, o2]
    | fn-obj(_, _, _) => empty
    | poly-obj(_, vs) => vs
  end
end

fun grow-removed(objs :: List<Obj>, removed :: List<String>) -> List<String>:
  more = objs.filter(lam(o):
    not(removed.member(o.name)) and refs(o).any(lam(r): removed.member(r) end)
  end)
  if is-empty(more):
    removed
  else:
    grow-removed(objs, removed + more.map(lam(o): o.name end))
  end
end

fun cascade-delete(objs :: List<Obj>, name :: String) -> List<Obj>:
  doc: "Removes an object and everything that depends on it"
  removed = grow-removed(objs, [list: name])
  objs.filter(lam(o): not(removed.member(o.name)) end)
end

fun safe-eval(f :: (Number -> Number), x :: Number) -> Option<Number>:
  doc: "f(x), or none if f raises an error (like 1/0) or returns a non-number"
  cases (Either) run-task(lam(): f(x) end):
    | left(v) =>
      if is-number(v):
        some(v)
      else:
        none
      end
    | right(_) => none
  end
end

# =======================================================================
# PART 3: view transforms and hit testing
# =======================================================================

fun to-sx(v :: View, x :: Number) -> Number:
  (W / 2) + ((x - v.cx) * v.ppu)
end

fun to-sy(v :: View, y :: Number) -> Number:
  (H / 2) - ((y - v.cy) * v.ppu)
end

fun to-wx(v :: View, sx :: Number) -> Number:
  v.cx + ((sx - (W / 2)) / v.ppu)
end

fun to-wy(v :: View, sy :: Number) -> Number:
  v.cy - ((sy - (H / 2)) / v.ppu)
where:
  v = view(2, 3, 40)
  to-wx(v, to-sx(v, 1.5)) is%(within-abs(0.000001)) 1.5
  to-wy(v, to-sy(v, -2.25)) is%(within-abs(0.000001)) -2.25
  # world y grows upward, screen y grows downward
  (to-sy(v, 4) < to-sy(v, 3)) is true
end

fun geo-dist-px(g :: Geo, v :: View, wx :: Number, wy :: Number) -> Number:
  doc: "How far, in pixels, the world point (wx,wy) is from the object"
  cases (Geo) g:
    | g-pt(x, y) => hypot(wx - x, wy - y) * v.ppu
    | g-line(x1, y1, x2, y2, bounded) =>
      if bounded:
        dist-point-segment(wx, wy, x1, y1, x2, y2) * v.ppu
      else:
        dist-point-line(wx, wy, x1, y1, x2, y2) * v.ppu
      end
    | g-circ(cx, cy, r) => num-abs(hypot(wx - cx, wy - cy) - r) * v.ppu
    | g-fn(f) =>
      cases (Option) safe-eval(f, wx):
        | some(y) => num-abs(y - wy) * v.ppu
        | none => 1000000
      end
    | g-poly(pts) =>
      n = pts.length()
      edge = lam(i):
        a = pts.get(i)
        b = pts.get(num-modulo(i + 1, n))
        dist-point-segment(wx, wy, a.x, a.y, b.x, b.y) * v.ppu
      end
      fold(lam(best, i): num-min(best, edge(i)) end, edge(0), range(1, n))
    | g-none => 1000000
  end
end

fun best-cand(cs :: List<Cand>) -> String:
  doc: "Name of the closest candidate (empty string if there are none)"
  cases (List) cs:
    | empty => ""
    | link(f, r) =>
      best = fold(lam(b, c): if c.d < b.d: c else: b end end, f, r)
      best.name
  end
end

fun hit-name(rs :: List<Res>, v :: View, mx :: Number, my :: Number) -> String:
  doc: "The object under the mouse: points win over other objects; empty string if nothing is close"
  wx = to-wx(v, mx)
  wy = to-wy(v, my)
  near = lam(r): cand(r.name, geo-dist-px(r.geo, v, wx, wy)) end
  pt-cands = rs.filter(lam(r): is-g-pt(r.geo) end).map(near)
    .filter(lam(c): c.d <= PICK-PT-PX end)
  if is-link(pt-cands):
    best-cand(pt-cands)
  else:
    obj-cands = rs.filter(lam(r): not(is-g-pt(r.geo)) and not(is-g-none(r.geo)) end).map(near)
      .filter(lam(c): c.d <= PICK-OBJ-PX end)
    best-cand(obj-cands)
  end
end

# =======================================================================
# PART 4: drawing
# =======================================================================

fun thick-line(scene :: Image, x1 :: Number, y1 :: Number,
               x2 :: Number, y2 :: Number, clr :: String) -> Image:
  doc: "A 2-pixel-wide line (scene-line itself is always 1 pixel)"
  if num-abs(x2 - x1) > num-abs(y2 - y1):
    scene-line(scene-line(scene, x1, y1, x2, y2, clr), x1, y1 + 1, x2, y2 + 1, clr)
  else:
    scene-line(scene-line(scene, x1, y1, x2, y2, clr), x1 + 1, y1, x2 + 1, y2, clr)
  end
end

fun nice-step(ppu :: Number) -> Number:
  doc: "A 'round' grid spacing (1, 2, 5, 10, ...) that is at least ~55 pixels wide"
  steps = [list: 0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000]
  cases (Option) steps.find(lam(s): (s * ppu) >= 55 end):
    | some(s) => s
    | none => 1000
  end
where:
  nice-step(40) is 2
  nice-step(400) is 0.2
  nice-step(8) is 10
end

fun grid-label(x :: Number, step :: Number) -> String:
  num-to-string-digits(x, if step >= 1: 0 else: 1 end)
end

fun draw-grid(scene :: Image, v :: View) -> Image:
  step = nice-step(v.ppu)
  xmin = to-wx(v, 0)
  xmax = to-wx(v, W)
  ymax = to-wy(v, 0)
  ymin = to-wy(v, H)
  kx = range(num-exact(num-ceiling(xmin / step)), num-exact(num-floor(xmax / step)) + 1)
  ky = range(num-exact(num-ceiling(ymin / step)), num-exact(num-floor(ymax / step)) + 1)
  ax-y = num-max(TB-H + 10, num-min(H - STATUS-H - 12, to-sy(v, 0)))
  ay-x = num-max(18, num-min(W - 26, to-sx(v, 0)))
  s1 = fold(lam(sc, k):
    sx = to-sx(v, k * step)
    scene-line(sc, sx, 0, sx, H, if k == 0: C-AXIS else: C-GRID end)
  end, scene, kx)
  s2 = fold(lam(sc, k):
    sy = to-sy(v, k * step)
    scene-line(sc, 0, sy, W, sy, if k == 0: C-AXIS else: C-GRID end)
  end, s1, ky)
  s3 = fold(lam(sc, k):
    if k == 0:
      sc
    else:
      place-image(text(grid-label(k * step, step), 11, C-AXIS), to-sx(v, k * step), ax-y + 9, sc)
    end
  end, s2, kx)
  fold(lam(sc, k):
    if k == 0:
      sc
    else:
      place-image(text(grid-label(k * step, step), 11, C-AXIS), ay-x - 12, to-sy(v, k * step), sc)
    end
  end, s3, ky)
end

fun draw-circle-poly(scene :: Image, v :: View, cx :: Number, cy :: Number,
                     r :: Number, clr :: String) -> Image:
  at = lam(i):
    ang = (2 * num-to-roughnum(3.141592653589793) * i) / CIRCLE-SEGS
    spt(to-sx(v, cx + (r * num-cos(ang))), to-sy(v, cy + (r * num-sin(ang))))
  end
  if (r * v.ppu) > 20000:
    scene
  else:
    fold(lam(sc, i):
      p = at(i)
      q = at(i + 1)
      thick-line(sc, p.sx, p.sy, q.sx, q.sy, clr)
    end, scene, range(0, CIRCLE-SEGS))
  end
end

fun draw-fn-curve(scene :: Image, v :: View, f :: (Number -> Number), clr :: String) -> Image:
  step-fn = lam(a, i):
    sx = i * FN-STEP-PX
    cases (Option) safe-eval(f, to-wx(v, sx)):
      | none => acc(a.scene, no-last)
      | some(y) =>
        sy = to-sy(v, y)
        if num-abs(sy) > 20000:
          acc(a.scene, no-last)
        else:
          cases (Last) a.last:
            | no-last => acc(a.scene, last-at(sx, sy))
            | last-at(px, py) =>
              if num-abs(sy - py) > H:
                acc(a.scene, last-at(sx, sy))
              else:
                acc(thick-line(a.scene, px, py, sx, sy, clr), last-at(sx, sy))
              end
          end
        end
    end
  end
  final = fold(step-fn, acc(scene, no-last), range(0, num-floor(W / FN-STEP-PX) + 1))
  final.scene
end

fun color-for(o :: Obj, hot :: Boolean, picked :: Boolean) -> String:
  if picked:
    C-PICKED
  else if hot:
    C-HOT
  else:
    cases (Obj) o:
      | free-pt(_, _, _) => C-FREE
      | mid-pt(_, _, _) => C-DERIVED
      | meet-pt(_, _, _, _) => C-DERIVED
      | line-obj(_, _, _) => C-LINE
      | seg-obj(_, _, _) => C-LINE
      | circ-obj(_, _, _) => C-CIRCLE
      | poly-obj(_, _) => C-POLY
      | fn-obj(_, _, _) => C-FN
    end
  end
end

fun draw-polygon(scene :: Image, v :: View, pts :: List<Geo>, clr :: String) -> Image:
  doc: "A translucent fill, a 2-pixel outline, and the area written at the middle"
  sp = pts.map(lam(p): spt(to-sx(v, p.x), to-sy(v, p.y)) end)
  n = sp.length()
  xs = sp.map(lam(p): p.sx end)
  ys = sp.map(lam(p): p.sy end)
  minx = fold(num-min, xs.first, xs)
  maxx = fold(num-max, xs.first, xs)
  miny = fold(num-min, ys.first, ys)
  maxy = fold(num-max, ys.first, ys)
  filled =
    if ((maxx - minx) > 4000) or ((maxy - miny) > 4000):
      scene
    else:
      shape = # point-polygon measures y upward, so the screen y offsets are negated
      point-polygon(sp.map(lam(p): point(p.sx - minx, miny - p.sy) end), "solid", color(70, 130, 220, 0.18))
      place-image(shape, (minx + maxx) / 2, (miny + maxy) / 2, scene)
    end
  outlined = fold(lam(sc, i):
    a = sp.get(i)
    b = sp.get(num-modulo(i + 1, n))
    thick-line(sc, a.sx, a.sy, b.sx, b.sy, clr)
  end, filled, range(0, n))
  cx = fold(lam(a, p): a + p.sx end, 0, sp) / n
  cy = fold(lam(a, p): a + p.sy end, 0, sp) / n
  place-image(text("area " + num-to-string-digits(poly-area(pts), 2), 12, clr), cx, cy, outlined)
end

fun draw-res(scene :: Image, v :: View, r :: Res, hov :: String, picked :: List<String>) -> Image:
  clr = color-for(r.obj, r.name == hov, picked.member(r.name))
  cases (Geo) r.geo:
    | g-pt(x, y) =>
      sx = to-sx(v, x)
      sy = to-sy(v, y)
      dot = overlay(circle(5, "solid", clr), circle(6, "outline", "black"))
      with-dot = place-image(dot, sx, sy, scene)
      place-image-align(text(r.name, 14, clr), sx + 8, sy - 8, "left", "bottom", with-dot)
    | g-line(_, _, _, _, _) =>
      cases (Clip) clip-line(r.geo, to-wx(v, 0), to-wx(v, W), to-wy(v, H), to-wy(v, 0)):
        | clip(x1, y1, x2, y2) =>
          thick-line(scene, to-sx(v, x1), to-sy(v, y1), to-sx(v, x2), to-sy(v, y2), clr)
        | no-clip => scene
      end
    | g-circ(cx, cy, rad) => draw-circle-poly(scene, v, cx, cy, rad, clr)
    | g-fn(f) => draw-fn-curve(scene, v, f, clr)
    | g-poly(pts) => draw-polygon(scene, v, pts, clr)
    | g-none => scene
  end
end

fun stack-left(imgs :: List<Image>) -> Image:
  fold(lam(a, b): beside(a, b) end, empty-image, imgs)
end

fun draw-toolbar(scene :: Image, s) -> Image:
  btn = lam(t):
    fill = if t.mode == s.mode: "light-steel-blue" else: "white" end
    inner = overlay(text(t.key + "  " + t.label, 13, "black"),
      rectangle(BTN-W - 2, TB-H - 2, "solid", fill))
    overlay(inner, rectangle(BTN-W, TB-H, "solid", "gray"))
  end
  row = stack-left(TOOLS.map(btn))
  bar = overlay-align("left", "middle", row, rectangle(W, TB-H, "solid", "white"))
  place-image(bar, W / 2, TB-H / 2, scene)
end

fun hint(mode :: String) -> String:
  if mode == "move":
    "Move: drag a point; drag the background to pan"
  else if mode == "point":
    "Point: click to place a point"
  else if mode == "midpoint":
    "Midpoint: click two points"
  else if mode == "line":
    "Line: click two points (empty space makes a new point)"
  else if mode == "segment":
    "Segment: click two points (empty space makes a new point)"
  else if mode == "circle":
    "Circle: click the center, then a point on the circle"
  else if mode == "intersect":
    "Intersect: click two lines, segments or circles"
  else if mode == "polygon":
    "Polygon: click vertices in order, then click the first vertex again to close"
  else if mode == "delete":
    "Delete: click an object (things built from it go too)"
  else:
    ""
  end
end

fun draw-status(scene :: Image, s) -> Image:
  v = s.view
  coords = "(" + num-to-string-digits(to-wx(v, s.mpx), 2) + ", "
    + num-to-string-digits(to-wy(v, s.mpy), 2) + ")"
  line1 = hint(s.mode) + (if s.msg == "": "" else: "   |   " + s.msg end)
  line2 = "keys: z undo   f function   n snap " + (if s.snap: "[on]" else: "[off]" end)
    + "   + / - zoom   arrows pan   0 reset   esc cancel      " + coords
  strip = rectangle(W, STATUS-H, "solid", "white")
  with-strip = place-image(strip, W / 2, H - (STATUS-H / 2), scene)
  with-rule = scene-line(with-strip, 0, H - STATUS-H, W, H - STATUS-H, "gray")
  l1 = place-image-align(text(line1, 13, "black"), 8, H - 32, "left", "middle", with-rule)
  place-image-align(text(line2, 12, "dim-gray"), 8, H - 12, "left", "middle", l1)
end

fun draw-state(s) -> Image:
  v = s.view
  rs = build-geo(s.objs)
  base = draw-grid(empty-color-scene(W, H, "white"), v)
  curves = rs.filter(lam(r): not(is-g-pt(r.geo)) end)
  points = rs.filter(lam(r): is-g-pt(r.geo) end)
  draw-one = lam(sc, r): draw-res(sc, v, r, s.hover, s.picked) end
  s1 = fold(draw-one, base, curves)
  s2 = fold(draw-one, s1, points)
  draw-status(draw-toolbar(s2, s), s)
end

# =======================================================================
# PART 5: state transitions
# =======================================================================

fun pt-name(n :: Number) -> String:
  if n < 26:
    string-substring(LETTERS, n, n + 1)
  else:
    "P" + num-to-string(n)
  end
where:
  pt-name(0) is "A"
  pt-name(25) is "Z"
  pt-name(26) is "P26"
end

fun snap-val(x :: Number, on :: Boolean) -> Number:
  if on:
    num-to-roughnum(num-round(x / SNAP-STEP) * SNAP-STEP)
  else:
    x
  end
where:
  snap-val(~1.3, true) is-roughly ~1.5
  snap-val(~1.3, false) is-roughly ~1.3
end

fun with-checkpoint(s, update :: (Any -> Any)):
  doc: "Runs update; if it changed the construction, remember the old one so z can undo it"
  s2 = update(s)
  if identical(s.objs, s2.objs):
    s2
  else:
    s2.{hist: link(s.objs, s2.hist)}
  end
end

fun set-mode(s, m :: String):
  s.{mode: m, picked: empty, drag: d-none, msg: ""}
end

fun is-free-name(objs :: List<Obj>, name :: String) -> Boolean:
  cases (Option) objs.find(lam(o): o.name == name end):
    | some(o) => is-free-pt(o)
    | none => false
  end
end

fun update-pt(objs :: List<Obj>, name :: String, x :: Number, y :: Number) -> List<Obj>:
  objs.map(lam(o):
    if (o.name == name) and is-free-pt(o):
      free-pt(name, x, y)
    else:
      o
    end
  end)
end

fun add-free-pt(s, x :: Number, y :: Number) -> PM:
  name = pt-name(s.npts)
  pm(s.{objs: s.objs + [list: free-pt(name, x, y)], npts: s.npts + 1}, name)
end

fun click-x(s, mx :: Number) -> Number:
  snap-val(to-wx(s.view, mx), s.snap)
end

fun click-y(s, my :: Number) -> Number:
  snap-val(to-wy(s.view, my), s.snap)
end

fun pick-or-make(s, rs :: List<Res>, hit :: String,
                 mx :: Number, my :: Number) -> PM:
  doc: "The point the user meant: the one under the mouse, or a brand-new free point there"
  if (hit <> "") and is-g-pt(geo-of(rs, hit)):
    pm(s, hit)
  else:
    add-free-pt(s, click-x(s, mx), click-y(s, my))
  end
end

fun finish-two(s, a :: String, b :: String):
  m = s.mode
  if m == "midpoint":
    n = pt-name(s.npts)
    s.{objs: s.objs + [list: mid-pt(n, a, b)], npts: s.npts + 1, picked: empty,
       msg: "added midpoint " + n}
  else:
    n = (if m == "line": "l" else if m == "segment": "s" else: "c" end) + num-to-string(s.nobjs + 1)
    o = if m == "line":
      line-obj(n, a, b)
    else if m == "segment":
      seg-obj(n, a, b)
    else:
      circ-obj(n, a, b)
    end
    s.{objs: s.objs + [list: o], nobjs: s.nobjs + 1, picked: empty, msg: "added " + n}
  end
end

fun pick-point-click(s, rs :: List<Res>, hit :: String,
                     mx :: Number, my :: Number):
  r = pick-or-make(s, rs, hit, mx, my)
  if r.s.picked.member(r.name):
    r.s.{msg: "choose a different point"}
  else:
    picked2 = r.s.picked + [list: r.name]
    if picked2.length() >= 2:
      finish-two(r.s, picked2.get(0), picked2.get(1))
    else:
      r.s.{picked: picked2, msg: "first point: " + r.name}
    end
  end
end

fun add-meet(s, o1 :: String, o2 :: String, which :: Number):
  n = pt-name(s.npts)
  s.{objs: s.objs + [list: meet-pt(n, o1, o2, which)], npts: s.npts + 1}
end

fun intersect-click(s, rs :: List<Res>, hit :: String):
  if (hit == "") or is-g-pt(geo-of(rs, hit)) or s.picked.member(hit):
    s.{msg: "click two different lines, segments or circles"}
  else:
    picked2 = s.picked + [list: hit]
    if picked2.length() < 2:
      s.{picked: picked2, msg: "first curve: " + hit}
    else:
      o1 = picked2.get(0)
      o2 = picked2.get(1)
      hits = meet(geo-of(rs, o1), geo-of(rs, o2))
      s1 = if is-g-pt(hits.get(0)): add-meet(s, o1, o2, 0) else: s end
      s2 = if is-g-pt(hits.get(1)): add-meet(s1, o1, o2, 1) else: s1 end
      if identical(s2.objs, s.objs):
        s2.{picked: empty, msg: "those two don't intersect"}
      else:
        s2.{picked: empty, msg: "added intersection point(s)"}
      end
    end
  end
end

fun polygon-click(s, rs :: List<Res>, hit :: String, mx :: Number, my :: Number):
  doc: "Collects vertices; clicking the first vertex again (after at least 3) closes the polygon"
  first-hit = is-link(s.picked) and (hit == s.picked.first)
  if first-hit and (s.picked.length() >= 3):
    n = "g" + num-to-string(s.nobjs + 1)
    s.{objs: s.objs + [list: poly-obj(n, s.picked)], nobjs: s.nobjs + 1,
       picked: empty, msg: "added polygon " + n}
  else if first-hit:
    s.{msg: "a polygon needs at least 3 vertices; keep clicking"}
  else:
    r = pick-or-make(s, rs, hit, mx, my)
    if r.s.picked.member(r.name):
      r.s.{msg: "already a vertex; click the first vertex to close"}
    else:
      r.s.{picked: r.s.picked + [list: r.name],
           msg: "vertex " + r.name + " (click the first vertex to close)"}
    end
  end
end

fun toolbar-click(s, mx :: Number):
  idx = num-floor(mx / BTN-W)
  if idx < TOOLS.length():
    set-mode(s, TOOLS.get(idx).mode)
  else:
    s
  end
end

fun mouse-down(s, mx :: Number, my :: Number):
  if my < TB-H:
    toolbar-click(s, mx)
  else:
    rs = build-geo(s.objs)
    hit = hit-name(rs, s.view, mx, my)
    m = s.mode
    if m == "move":
      if (hit <> "") and is-free-name(s.objs, hit):
        s.{drag: d-pt(hit, s.objs)}
      else:
        s.{drag: d-pan(mx, my)}
      end
    else if m == "point":
      with-checkpoint(s, lam(t):
        add-free-pt(t, click-x(t, mx), click-y(t, my)).s.{msg: "added a point"}
      end)
    else if m == "polygon":
      with-checkpoint(s, lam(t): polygon-click(t, rs, hit, mx, my) end)
    else if m == "intersect":
      with-checkpoint(s, lam(t): intersect-click(t, rs, hit) end)
    else if m == "delete":
      if hit == "":
        s
      else:
        with-checkpoint(s, lam(t):
          t.{objs: cascade-delete(t.objs, hit), picked: empty, hover: "", msg: "deleted " + hit}
        end)
      end
    else:
      with-checkpoint(s, lam(t): pick-point-click(t, rs, hit, mx, my) end)
    end
  end
end

fun mouse-drag(s, mx :: Number, my :: Number):
  cases (Drag) s.drag:
    | d-pt(name, _) =>
      s.{objs: update-pt(s.objs, name, click-x(s, mx), click-y(s, my))}
    | d-pan(px, py) =>
      v = s.view
      s.{view: view(v.cx - ((mx - px) / v.ppu), v.cy + ((my - py) / v.ppu), v.ppu),
         drag: d-pan(mx, my)}
    | d-none => s
  end
end

fun end-drag(s):
  cases (Drag) s.drag:
    | d-pt(_, start) =>
      if identical(start, s.objs):
        s.{drag: d-none}
      else:
        s.{drag: d-none, hist: link(start, s.hist)}
      end
    | else => s.{drag: d-none}
  end
end

fun handle-mouse(s, mx0 :: Number, my0 :: Number, ev :: String):
  mx = num-to-roughnum(mx0)
  my = num-to-roughnum(my0)
  s1 = s.{mpx: mx, mpy: my}
  if ev == "button-down":
    mouse-down(s1, mx, my)
  else if ev == "drag":
    mouse-drag(s1, mx, my)
  else if (ev == "button-up") or (ev == "leave"):
    end-drag(s1)
  else if ev == "move":
    s1.{hover: hit-name(build-geo(s1.objs), s1.view, mx, my)}
  else:
    s1
  end
end

fun zoom(s, factor :: Number):
  v = s.view
  s.{view: view(v.cx, v.cy, num-max(MIN-SCALE, num-min(MAX-SCALE, v.ppu * factor)))}
end

fun pan-keys(s, dx :: Number, dy :: Number):
  v = s.view
  step = 40 / v.ppu
  s.{view: view(v.cx + (dx * step), v.cy + (dy * step), v.ppu)}
end

fun undo(s):
  cases (List) s.hist:
    | empty => s.{msg: "nothing to undo"}
    | link(prev, rest) =>
      s.{objs: prev, hist: rest, picked: empty, drag: d-none, hover: "", msg: "undone"}
  end
end

fun add-function(s):
  if is-empty(s.fns):
    s.{msg: "no preset functions were supplied"}
  else:
    spec = s.fns.get(num-modulo(s.nfn, s.fns.length()))
    n = "f" + num-to-string(s.nobjs + 1)
    with-checkpoint(s, lam(t):
      t.{objs: t.objs + [list: fn-obj(n, spec.label, spec.f)],
         nobjs: t.nobjs + 1, nfn: t.nfn + 1, msg: "added " + n + " = " + spec.label}
    end)
  end
end

fun other-key(s, k :: String):
  if k == "z":
    undo(s)
  else if k == "f":
    add-function(s)
  else if k == "n":
    s.{snap: not(s.snap), msg: if s.snap: "snap off" else: "snap on" end}
  else if (k == "+") or (k == "="):
    zoom(s, 5/4)
  else if (k == "-") or (k == "_"):
    zoom(s, 4/5)
  else if k == "left":
    pan-keys(s, -1, 0)
  else if k == "right":
    pan-keys(s, 1, 0)
  else if k == "up":
    pan-keys(s, 0, 1)
  else if k == "down":
    pan-keys(s, 0, -1)
  else if k == "0":
    s.{view: view(0, 1, 40)}
  else if k == "escape":
    s.{picked: empty, drag: d-none, msg: ""}
  else:
    s
  end
end

fun handle-key(s, key :: String):
  k = string-to-lower(key)
  cases (Option) TOOLS.find(lam(t): t.key == k end):
    | some(t) => set-mode(s, t.mode)
    | none => other-key(s, k)
  end
end

# =======================================================================
# PART 6: the applet
# =======================================================================

fun initial-state(fns :: List<FnSpec>):
  doc: "A small starting construction, so there is something to drag right away"
  objs = [list:
    free-pt("A", -3, -1),
    free-pt("B", 3, 0.5),
    free-pt("C", -0.5, 3),
    seg-obj("s1", "A", "B"),
    circ-obj("c1", "C", "A"),
    line-obj("l1", "B", "C"),
    meet-pt("D", "l1", "c1", 0),
    meet-pt("E", "l1", "c1", 1),
    mid-pt("F", "A", "B")
  ]
  st(objs, empty, view(0, 1, 40), "move", empty, d-none, 6, 3, "", 0, 0,
    false, fns, 0, "")
end

fun geo-applet-with(fns :: List<FnSpec>):
  doc: "Launches the applet; fns are the preset curves the f key adds, in order"
  r = reactor:
    init: initial-state(fns),
    to-draw: draw-state,
    on-key: handle-key,
    on-mouse: handle-mouse,
    title: "GEO-LITE"
  end
  result = interact(r)
  nothing
end

fun geo-applet():
  doc: "Launches the applet with the default preset curves"
  geo-applet-with(DEFAULT-FNS)
end

# =======================================================================
# TESTS: the construction logic, driven the same way the reactor drives it
# =======================================================================

check "initial construction evaluates":
  s = initial-state(DEFAULT-FNS)
  rs = build-geo(s.objs)
  rs.length() is 9
  # F is the midpoint of A(-3,-1) and B(3,0.5)
  f = geo-of(rs, "F")
  f.x is%(within-abs(0.000001)) 0
  f.y is%(within-abs(0.000001)) -0.25
  # D and E both lie on circle c1 (center C, through A)
  c1 = geo-of(rs, "c1")
  d = geo-of(rs, "D")
  e = geo-of(rs, "E")
  hypot(d.x - c1.cx, d.y - c1.cy) is%(within-abs(0.000001)) c1.r
  hypot(e.x - c1.cx, e.y - c1.cy) is%(within-abs(0.000001)) c1.r
  # ... and on line l1 (through B and C)
  l1 = geo-of(rs, "l1")
  dist-point-line(d.x, d.y, l1.x1, l1.y1, l1.x2, l1.y2) is%(within-abs(0.000001)) 0
end

check "hit testing (A is at screen (290, 370) in the starting view)":
  s = initial-state(DEFAULT-FNS)
  rs = build-geo(s.objs)
  hit-name(rs, s.view, 290, 370) is "A"
  hit-name(rs, s.view, 294, 366) is "A"
  # empty corner of the window
  hit-name(rs, s.view, 780, 120) is ""
end

check "dragging a free point moves everything built from it":
  s0 = initial-state(DEFAULT-FNS)
  s1 = handle-mouse(s0, 290, 370, "button-down")
  is-d-pt(s1.drag) is true
  s2 = handle-mouse(s1, 330, 370, "drag")
  s3 = handle-mouse(s2, 330, 370, "button-up")
  rs = build-geo(s3.objs)
  a = geo-of(rs, "A")
  a.x is%(within-abs(0.000001)) -2
  a.y is%(within-abs(0.000001)) -1
  # the midpoint F followed A: ((-2)+3)/2 = 0.5
  geo-of(rs, "F").x is%(within-abs(0.000001)) 0.5
  # the drag was recorded as one undo step, and undo puts A back
  s3.hist.length() is 1
  s4 = handle-key(s3, "z")
  geo-of(build-geo(s4.objs), "A").x is%(within-abs(0.000001)) -3
end

check "dragging the background pans the view":
  s0 = initial-state(DEFAULT-FNS)
  s1 = handle-mouse(s0, 700, 100, "button-down")
  is-d-pan(s1.drag) is true
  s2 = handle-mouse(s1, 740, 100, "drag")
  # dragging right ey 40px = 1 unit moves the view center left ey 1
  s2.view.cx is%(within-abs(0.000001)) -1
  s2.view.cy is%(within-abs(0.000001)) 1
end

check "construction tools":
  s0 = initial-state(DEFAULT-FNS)
  # Segment tool: two clicks on empty space make two points and a segment
  s1 = handle-key(s0, "s")
  s1.mode is "segment"
  s2 = handle-mouse(s1, 100, 300, "button-down")
  s2.objs.length() is 10
  s3 = handle-mouse(s2, 500, 300, "button-down")
  s3.objs.length() is 12
  is-seg-obj(s3.objs.get(11)) is true
  # each click that changed things is one undo step
  s3.hist.length() is 2
  handle-key(handle-key(s3, "z"), "z").objs.length() is 9
  # Midpoint tool using existing points A and B
  m0 = handle-key(s0, "m")
  m1 = handle-mouse(m0, 290, 370, "button-down")
  m1.objs.length() is 9
  m2 = handle-mouse(m1, 530, 310, "button-down")
  is-mid-pt(m2.objs.get(9)) is true
  # Point tool with snapping on rounds to the nearest half unit
  p0 = handle-key(handle-key(s0, "n"), "p")
  p1 = handle-mouse(p0, 330, 270, "button-down")
  newp = geo-of(build-geo(p1.objs), "G")
  newp.x is%(within-abs(0.000001)) -2
  newp.y is%(within-abs(0.000001)) 1.5
end

check "intersect and delete":
  s0 = initial-state(DEFAULT-FNS)
  # Intersect tool: click segment s1 (A to B) then line l1 (B to C) near B... they meet at B
  i0 = handle-key(s0, "i")
  # a spot on segment s1, far from every point: point at screen (350, 355), a quarter of the way from A to B
  i1 = handle-mouse(i0, 350, 355, "button-down")
  i1.picked.length() is 1
  # click on nothing: rejected, nothing is added
  i2 = handle-mouse(i1, 780, 120, "button-down")
  i2.objs.length() is 9
  # Delete tool: removing A also removes everything built from A
  d0 = handle-key(s0, "x")
  d1 = handle-mouse(d0, 290, 370, "button-down")
  # left: B, C, l1
  d1.objs.length() is 3
  handle-key(d1, "z").objs.length() is 9
end

check "keys: tools, zoom, functions, undo":
  s0 = initial-state(DEFAULT-FNS)
  handle-key(s0, "L").mode is "line"
  zoom(s0, 5/4).view.ppu is%(within-abs(0.000001)) 50
  # zoom is clamped
  zoom(s0, 100).view.ppu is%(within-abs(0.000001)) 400
  zoom(s0, 1/100).view.ppu is%(within-abs(0.000001)) 8
  # f adds the first preset function, then the next one
  f1 = handle-key(s0, "f")
  f1.objs.length() is 10
  is-fn-obj(f1.objs.get(9)) is true
  f1.objs.get(9).label is "sin(x)"
  handle-key(f1, "f").objs.get(10).label is "x^2 / 4"
  handle-key(f1, "z").objs.length() is 9
  # undo with nothing to undo is harmless
  handle-key(s0, "z").objs.length() is 9
end

check "function evaluation survives errors":
  safe-eval(lam(x): 1 / x end, 0) is none
  safe-eval(lam(x): x + 1 end, 2) is some(3)
end

check "polygon tool":
  s0 = initial-state(DEFAULT-FNS)
  # A(290,370), B(530,310), C(390,210) in the starting view
  g0 = handle-key(s0, "g")
  g0.mode is "polygon"
  g1 = handle-mouse(g0, 290, 370, "button-down")
  g2 = handle-mouse(g1, 530, 310, "button-down")
  # closing with only two vertices is refused
  is-poly-obj(handle-mouse(g2, 290, 370, "button-down").objs.last()) is false
  g3 = handle-mouse(g2, 390, 210, "button-down")
  g3.picked is [list: "A", "B", "C"]
  g4 = handle-mouse(g3, 290, 370, "button-down")
  g4.objs.length() is 10
  is-poly-obj(g4.objs.get(9)) is true
  g4.objs.get(9).verts is [list: "A", "B", "C"]
  g4.picked is empty
  # the triangle (-3,-1),(3,0.5),(-0.5,3) has area |(-3)(0.5-3)+3(3-(-1))+(-0.5)(-1-0.5)|/2
  geo = geo-of(build-geo(g4.objs), "g4")
  is-g-poly(geo) is true
  poly-area(geo.pts) is%(within-abs(0.000001)) 10.125
  # clicking empty space adds new free points as vertices
  e1 = handle-mouse(handle-mouse(handle-mouse(g0, 700, 100, "button-down"), 760, 100, "button-down"),
    760, 200, "button-down")
  e1.objs.length() is 12
  handle-mouse(e1, 700, 100, "button-down").objs.length() is 13
  # an edge can be picked (midpoint of edge A-B is F at (410, 340); use a spot a quarter along)
  hit-name(build-geo(g4.objs), g4.view, 350, 355) is "s1"
  # dragging a vertex reshapes the polygon, and deleting a vertex deletes the polygon
  d0 = handle-key(g4, "x")
  handle-mouse(d0, 290, 370, "button-down").objs.filter(is-poly-obj) is empty
  # undo removes the polygon in one step
  handle-key(g4, "z").objs.length() is 9
end
