
/******************************************************************************
* MODULE     : tm_debug.cpp
* DESCRIPTION: Debugging facilities
* COPYRIGHT  : (C) 2011  Joris van der Hoeven
*              (C) 2008  Timo Bingmann from http://idlebox.net
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <execinfo.h>
#include <cxxabi.h>
#include "tm_server.hpp"
#include "file.hpp"

/******************************************************************************
* Run-time routine for obtaining a stack trace. This function was written
* by Timo Bingmann and further improved (and published under the WTFPL v2.0)
* and further improved by Joris van der Hoeven
******************************************************************************/

/** Print a demangled stack backtrace of the caller function to FILE* out. */
string
get_stacktrace (unsigned int max_frames= 127) {
#ifdef USE_STACK_TRACE
  string r;
  r << "Backtrace of C++ stack:\n";
  
  // storage array for stack trace address data
  void* addrlist[max_frames+1];

  // retrieve current stack addresses
  int addrlen = backtrace (addrlist, sizeof (addrlist) / sizeof (void*));

  if (addrlen == 0) {
    r << "  <empty, possibly corrupt>\n";
    return r;
  }

  // resolve addresses into strings containing "filename(function+address)",
  // this array must be free()-ed
  char** symbollist = backtrace_symbols (addrlist, addrlen);

  // allocate string which will be filled with the demangled function name
  size_t funcnamesize = 1024;
  char* funcname = (char*) malloc (funcnamesize);

  // iterate over the returned symbol lines. skip the first, it is the
  // address of this function.
  for (int i = 1; i < addrlen; i++) {
    char *begin_name = 0, *end_name = 0, *begin_offset = 0, *end_offset = 0;

    // find parentheses and +address offset surrounding the mangled name:
    // ./module(function+0x15c) [0x8048a6d]
    for (char *p = symbollist[i]; *p; ++p) {
      if (*p == '(')
        begin_name = p;
      else if (*p == '+') {
        end_name = p;
        begin_offset = p;
      }
      else if (*p == ')' && begin_offset) {
        end_offset = p;
        break;
      }
    }
    
    bool ok= begin_name && end_offset && begin_name < end_name;
    if (ok) {
      begin_name++;
      begin_offset++;
    }
    else if (begin_offset) {
      begin_offset++;
      while (begin_offset[0] == ' ') begin_offset++;
      for (char* p= begin_offset; true; ++p)
        if (*p == '\0') {
          end_offset = p;
          break;
        }
      while (end_name[-1] == ' ') end_name--;
      for (char* p= end_name; *p; --p)
        if (p == symbollist[i] || p[-1] == ' ') {
          begin_name = p;
          break;
        }
      ok= begin_offset < end_offset && begin_name < end_name;
    }

    if (ok) {
      while (end_name[-1] == ' ') end_name--;
      while (begin_offset[0] == ' ') begin_offset++;
      begin_name[-1] = '\0';
      end_name[0] = '\0';
      begin_offset[-1] = '\0';
      end_offset[0] = '\0';

      // mangled name is now in [begin_name, end_name) and caller
      // offset in [begin_offset, end_offset). now apply
      // __cxa_demangle():

      int status;
      char* ret =
        abi::__cxa_demangle (begin_name, funcname, &funcnamesize, &status);
      if (status == 0) {
        funcname = ret; // use possibly realloc()-ed string
        r << "  " << symbollist[i]
          << " : " << funcname
          << " + " << begin_offset << "\n";
      }
      else {
        // demangling failed. Output function name as a C function with
        // no arguments.
        r << "  " << symbollist[i]
          << " : " << begin_name << "()"
          << " + " << begin_offset << "\n";
      }
    }
    else {
      // couldn't parse the line? print the whole line.
      r << "  " << symbollist[i] << "\n";
    }
  }

  free (funcname);
  free (symbollist);
  return r;
#else
  return "Backtrace of C++ stack not supported\n";
#endif
}

/******************************************************************************
* Crash management
******************************************************************************/

string
get_crash_report () {
  return get_stacktrace ();
}

void
tm_failure (const char* msg) {
  cerr << "TeXmacs] Fatal error, " << msg << "\n";
  string report= get_crash_report ();
  url dir ("$TEXMACS_HOME_PATH/system/crash");
  url err= url_numbered (dir, "crash_report_", "");
  if (!save_string (err, report))
    cerr << "TeXmacs] Crash report saved in " << err << "\n";
  else
    cerr << "TeXmacs] Crash report could not be saved in " << err << "\n"
         << "TeXmacs] Dumping report below\n\n"
         << report;
}
