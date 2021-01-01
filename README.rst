========
VIM.WOLF
========

The syntax file for Mathematica language for Vim.

Note
----

This syntax is made (and is under slow construction) in order to meet some
author requirements for the development of other things, so it will be slowly
evolving towards some unspecified unpredictable wishes of the author, which may
and will be varying over time.

Features
--------

* Mathematica version specific keywords:
   This allows to separate "older" and "newer" ``System`` symbols with respect
   to some version of Mathematica.
* Different brackets are highlighted differently:
   This allows to avoid fances of brackets in the end of functions.
* Contexts are highlighted separately:
   In large packages this is a necessity. But names of contexts themselves might
   be necessary only syntaxically. In order to simplify the visual look one can
   make context names almost invisible.

Installation
------------

In order to install, run::

   ./install

One may wish to specify use different options for intallation (several options
can be used simultaneously):

* [-v number] "version number"
   The version of Mathematica can be specified, which will separate older and
   newer ``System`` symbols. Default version is ``7.0``. The installation is
   done in the following way::

      ./install -v <number>

* [-h] "hide highlighting"
   Some colors are defined in this syntax. They are author specific and may be
   undesired. To use your highlighting::

      ./install -n

Testing
-------

In order to test, run::

   ./check

It will create ``.html`` files and check them against the ``.test`` ones. The
last ones are created in exactly the same way, how in ``check`` script.

* [-f] "full test"
   This flag forces to use ``install`` script first. Testing is done in
   the following way::

      ./check -f


