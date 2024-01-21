# metacode (c edition)

a tool to allow metaprogramming via common lisp for any language that supports c-like `/* */` comments

i might expand it to work with other langs later on, but for now, c is
enough. actually, *you* could expand it, it's open source! (though i
don't expect that at all, i made this mostly for myself)

i only use sbcl, so you *will* have to modify **at least** `run.sh` to
use anything else. (`metacode.lisp` itself *should* support sbcl, clisp,
and cmucl, though again, clisp and cmucl are untested)

## syntax

`/*lisp [lisp code] *lisp*/`

if `[lisp code]` evaluates to a string, the `/*lisp* *lisp*/` block
will be replaced with that string, otherwise the block will be removed
entirely.

## cli usage

`-i input-path` (mandatory)

`-o output-path` (mandatory)

these are the only arguments, there's no reading files from stdin or
anything fancy yet, just `i` and `o`.

### one-time setup

make a **softlink** to the `run.sh` script wherever you want to use
it. i recommend doing something like

```
cd [metacode_c path]
ln -s ./run.sh /usr1/bin/metacode
```

so that you can run it as metacode from wherever, as you might gcc.

you **must** softlink and not copy, because it uses realpath to get
the original file's path, and that won't work with a copy. (yes, this
is a hack. yes, i'm not going to 'fix' it because it works well enough)

### if it doesn't work

make sure that you have SBCL, ASDF, Quicklisp, and CL-PPCRE installed
and fully set up, and if the core file doesn't work properly, run
`build.sh`.

if that doesn't help, contact me and i'll try to help.

## shameless plug

if you want help with it or find a bug or whatever, you can contact me through discord: https://discord.gg/DAuUSrr3yz

i'm also on IRC (libera.chat and oftc.net), though i don't know how you'd get to me through there. maybe `/msg hexa6`?

## license

GPL v3.0.

it's a standalone tool, why should it be anything else?
