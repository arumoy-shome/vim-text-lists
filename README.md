# vim-text-lists

This plugin provides utility functions for working with lists in (neo)vim. Namely, the plugin provides the following functionality:

1. automatically continues an ordered or unordered list in both directions.
1. toggle between the following states: unordered list item -> incomplete task -> complete task -> unordered list item (md, txt and git buffers only).

# Supported filetypes

Currently markdown, text, git and tex filetypes are supported. The same list markers are assumed for markdown, text and git buffers. The supported list markers can be found in `vtl#get_marker_pattern`.

# Key bindings

- `<CR>` in insert mode: continue list below.
- `o` in normal mode: continue list below.
- `O` in normal mode: continue list above.
- `<C-c C-c` (hold `ctrl` and press `c` twice) in normal mode: toggle between list states.

# Installation

Use your preferred mode of installation either with your favourite plugin manager or simply use git.

# Requirements

I assume it should work fine on recent versions of vim and neovim.

# Rational

Currently `-` and `*` are recognized as unordered list markers. For ordered list, the number of the previous line is used since markdown automatically takes care of incrementing the numbers when rendering. Supporting auto increment is possible but opens up a lot of edge cases that need to be handled (e.g. negative numbers). Of course contributions are more than welcome if anybody wants to implement this feature!

Of course, for tex things are simpler as we only have one marker namely `\item` and the environment defines if we want the list to be ordered or unordered.

# Contributions

They are more than welcome! I assume there are plenty of bugs so definitely open an issue if you find something.

# Licence

This project is open sourced under the MIT licence.
