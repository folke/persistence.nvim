# Changelog

## 1.0.0 (2023-01-04)


### ⚠ BREAKING CHANGES

* save sessions in state instead of config

### Features

* added config options ([a39f3f1](https://github.com/folke/persistence.nvim/commit/a39f3f10c836709f9b6e009b20a1f028851c50e0))
* inital version ([8b32094](https://github.com/folke/persistence.nvim/commit/8b32094309ee986066c219d2b4d88a4045fbcb8c))
* save sessions in state instead of config ([c304745](https://github.com/folke/persistence.nvim/commit/c30474509666187181add6122e775f9978478c81))


### Bug Fixes

* dont show errors when loading a session ([ad7fcd4](https://github.com/folke/persistence.nvim/commit/ad7fcd4fed0cecb9ae3c6cbc4a61801ef4e2466d))
* properly escape session file names on Windows ([#7](https://github.com/folke/persistence.nvim/issues/7)) ([83af96b](https://github.com/folke/persistence.nvim/commit/83af96b1f205dddab066c96b029ceeee192b48d4))
* renamed session to persistence in autocmds ([38203a1](https://github.com/folke/persistence.nvim/commit/38203a17a97d49bfcc938f171ecfa44f52dda08e))
* vim.fn.has('win32') returns 0 or 1, not a boolean ([#8](https://github.com/folke/persistence.nvim/issues/8)) ([77cf5a6](https://github.com/folke/persistence.nvim/commit/77cf5a6ee162013b97237ff25450080401849f85))
