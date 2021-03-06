
/******************************************************************************
* MODULE     : scalable.cpp
* DESCRIPTION: Abstract scalable vector graphics
* COPYRIGHT  : (C) 2013  Joris van der Hoeven
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/

#include "scalable.hpp"
#include "renderer.hpp"
#include "picture.hpp"

/******************************************************************************
* Default implementations of virtual methods
******************************************************************************/

url scalable_rep::get_name () { return url_none (); }

/******************************************************************************
* The abstract scalable class
******************************************************************************/

class scalable_image_rep: public scalable_rep {
  url u;
  SI w, h;
  SI px;
public:
  scalable_image_rep (url u2, SI w2, SI h2, SI px2):
    u (u2), w (w2), h (h2), px (px2) {
      picture_cache_reserve (u, w/px, h/px); }
  ~scalable_image_rep () {
    picture_cache_release (u, w/px, h/px); }

  scalable_kind get_type () { return scalable_image; }
  void* get_handle () { return (void*) this; }
  url get_name () { return u; }

  rectangle get_logical_extents () {
    return rectangle (0, 0, w, h); }
  rectangle get_physical_extents () {
    return rectangle (0, 0, w, h); }
  void draw (renderer ren, SI x, SI y, int alpha) {
    picture pict= cached_load_picture (u, w/ren->pixel, h/ren->pixel, false);
    ren->draw_picture (pict, x, y, alpha); }
};

scalable
load_scalable_image (url file_name, SI w, SI h, SI pixel) {
  return tm_new<scalable_image_rep> (file_name, w, h, pixel);
}
