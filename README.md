# tasklists.nvim

Simple utilities for simple markdown tasklists.

## Features

- **Toggle tasks**: Toggle between various todo states, even affecting parent and child tasks.

```
- ensure markdown parser is installed

- only enable if the current treesitter parser is `markdown`
- build tree of tasks on bufwritepost, bufread, bufnew (if filetype is `markdown`)
- toggle statuses
  - `incomplete`
  - `complete`
- affect parents
- affect children
- dot repeat
- additonal statuses
  - `in_progress`
  - `cancelled`
- api
  - mark
  - toggle
  - cycle - `incomplete -> in_progress -> complete -> cancelled`
- config
  - how each status is displayed as a string
  - how each status affects its parents & children ("none" | "parents" | "children" | "all")
  - how each status affects its parents & children ("none" | "parents" | "children" | "all")
- cmds
  - `PluginName mark status`
  - `PluginName toggle`
  - `PluginName cycle`
- create a new task on:
  - new line
  - `o`
  - `O`
- dot repeat
- turn into plugin
  - README
  - vim help doc
  - render-markdown integration
  - require `nvim-treesitter/nvim-treesitter`
- post it
- issues
  - support visual selection
  - support `markdown_inline`
```

## Installation

Install `tasklists.nvim` using your favorite plugin manager.

**[lazy.nvim](https://github.com/folke/lazy.nvim)**:

```lua
{
  'r0nsha/tasklists.nvim',
  opts = {
    -- Your custom configuration goes here
  }
}
```

**[packer.nvim](https://github.com/wbthomason/packer.nvim)**:

```lua
use({
  'r0nsha/tasklists.nvim',
  config = function()
    require('tasklists').setup({
      -- Your custom configuration goes here
    })
  end
})
```

## Configuration

Here are the default configuration options:

```lua
require('tasklists').setup({
})
```

## Contributing

Contributions are always welcome! If you find any bugs or have a feature request, you're welcome to open an issue or submit a pull request.

## Acknowledgements

- [checkmate.nvim](https://github.com/bngarren/checkmate.nvim) - This is the plugin I used before I created this one.
