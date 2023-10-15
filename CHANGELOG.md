# Changelog

## [2.0.0](https://github.com/folke/persistence.nvim/compare/v1.2.1...v2.0.0) (2023-10-15)


### ⚠ BREAKING CHANGES

* **start:** session name is now based on the cwd when the session starts and not when the session ends. Fixes #1688

### Bug Fixes

* **start:** session name is now based on the cwd when the session starts and not when the session ends. Fixes [#1688](https://github.com/folke/persistence.nvim/issues/1688) ([0361df7](https://github.com/folke/persistence.nvim/commit/0361df7775f5b4ed51a6d7fe159438573b7f07a6))

## [1.2.1](https://github.com/folke/persistence.nvim/compare/v1.2.0...v1.2.1) (2023-10-13)


### Bug Fixes

* dont save the session when only `gitcommit` buffers are present. Fixes [#14](https://github.com/folke/persistence.nvim/issues/14) ([8f7cbcc](https://github.com/folke/persistence.nvim/commit/8f7cbccfb506fe6cb35db9ad966137c363b049c5))

## [1.2.0](https://github.com/folke/persistence.nvim/compare/v1.1.0...v1.2.0) (2023-10-13)


### Features

* don't save the session when no files are open (save_empty = false) ([e9afeaf](https://github.com/folke/persistence.nvim/commit/e9afeaf3a7bb645ca73980cd13048c48c292500c))

## [1.1.0](https://github.com/folke/persistence.nvim/compare/v1.0.1...v1.1.0) (2023-02-28)


### Features

* **persistence:** `pre_save` option to call before saving ([#22](https://github.com/folke/persistence.nvim/issues/22)) ([f4bb0c5](https://github.com/folke/persistence.nvim/commit/f4bb0c5641a0e6c9ac3675ddd794ca78099d8510))

## [1.0.1](https://github.com/folke/persistence.nvim/compare/v1.0.0...v1.0.1) (2023-01-06)


### Bug Fixes

* dont throw error when session was already stopped ([70c281e](https://github.com/folke/persistence.nvim/commit/70c281e54e34630d8bef9b1cf9f7a0ac3edd6a1c))

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
