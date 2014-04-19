# Word Thing

I'm not sure where I'm headed with this. It may end up being just a library.

## What there is

So far I have

### Large word list

wtwords.txt is constructed from Kevin Atkinson's [wordlist page](http://wordlist.sourceforge.net/). 
I have included the whole copyright file that comes with the download, since
all the component word lists have ultimately been placed in the public domain, 
but there are a number of different statements of copyright contained. Clearly,
I am deeply in Kevin's debt for the word list and acknowledge the sterling work
that he has done.

The word list that I have chosen to construct from his files is:

- Level 60, with...
- English and British up to variant 1.
- No possessives ('s), abbreviations, proper names, Roman numerals, or hacker words. 
- Word lengths 3 to 12.

### Playing Grid

There is now a 10x10 playing grid that allows selecting of letters using the mouse.
18 words of varying sizes are inserted.

## gosu_enhanced gem

It now uses the gosu_enhanced gem that I created from the source file that
I've been using in various forms for a while.
