<TeXmacs|1.0.7.18>

<style|tmweb>

<\body>
  <tmweb-current|Download|Linux><tmweb-title|Installing <TeXmacs> on
  GNU/<name|Linux> systems|<tmweb-download-links>>

  <section|Installation method>

  Depending on your GNU/<name|Linux> distribution, you may choose between the
  following installation methods:

  <\enumerate>
    <item>Please <hlink|check|linux.en.tm> whether your distribution already
    supports <TeXmacs>, in which case you may directly install <TeXmacs>
    using the standard tools of your system.

    <item>If your system admits an RPM-compatible package manager, then you
    may try to install our <hlink|generic RPM package|rpm.en.tm>.

    <item>Otherwise, you may install a generic binary package for <TeXmacs>,
    as explained below.
  </enumerate>

  If you are interested in packaging <TeXmacs> for a new GNU/<name|Linux> or
  <name|Unix> distribution, then please take a look at our
  <hlink|suggestions|packaging.en.tm>.

  <section|Download the package>

  Download the <hlink|most-recent|<merge|http://www.texmacs.org/Download/ftp/tmftp/generic/|<TeXmacs-version-release|devel>|-x11-i386-pc-linux-gnu.tar.gz>>
  or <hlink|last stable|<merge|http://www.texmacs.org/Download/ftp/tmftp/generic/|<merge|<TeXmacs-version-release|stable>|-x11-i386-pc-linux-gnu.tar.gz>>>
  static binary distribution of GNU <TeXmacs> for standard Intel or AMD based
  PC's under GNU/<name|Linux>.

  <section|Unpack the package>

  In a shell session, <verbatim|cd> into the directory where you wish to
  install <TeXmacs> and type

  <\shell-code>
    gunzip -c TeXmacs-<with|color|brown|[version]>-<with|color|brown|[your
    system]>.tar.gz \| tar xvf -
  </shell-code>

  All files will be unpacked into the directory
  <with|font-family|tt|TeXmacs-<with|color|brown|[version]>-<with|color|brown|[your
  system]>> (or <with|font-family|tt|TeXmacs-<with|color|brown|[version]>>,
  for some older versions). Let <with|font-family|tt|<with|color|brown|[installation
  directory]>> be the full path of this directory.

  <section|Set the environment variables>

  Depending on your shell, either type

  <\shell-code>
    export TEXMACS_PATH=<with|color|brown|[installation directory]>

    export PATH=$TEXMACS_PATH/bin:$PATH
  </shell-code>

  or

  <\shell-code>
    setenv TEXMACS_PATH <with|color|brown|[installation directory]>

    setenv PATH $TEXMACS_PATH/bin:$PATH
  </shell-code>

  where <with|font-family|tt|<with|color|brown|[installation directory]>> is
  as in step 2. We recommend to put these lines in your personal startup
  script, such as <with|font-family|tt|.bash_profile>.

  <section|Happy <TeXmacs>-ing!>

  You should now be able to run the program:

  <\code>
    \ \ \ \ texmacs &
  </code>

  If you like the program, then please consider
  <hlink|donating|../contribute/donations.en.tm> money or services to us. Of
  course, you may also <hlink|contribute|../contribute/contribute.en.tm>
  yourself. In case of problems, please <hlink|subscribe|../home/ml.en.tm> to
  the <verbatim|texmacs-dev> or <verbatim|texmacs-users> mailing lists and
  ask your questions there. You may also directly
  <hlink|contact|../contact/contact.en.tm> us, but you might need to be more
  patient.

  <tmdoc-copyright|1999--2011|Joris van der Hoeven>

  <tmweb-license>
</body>

<\initial>
  <\collection>
    <associate|language|english>
  </collection>
</initial>