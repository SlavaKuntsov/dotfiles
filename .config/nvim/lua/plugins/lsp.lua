return {
	-- tools
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"luacheck",
				--			"shellcheck",
				"shfmt",
				"stylua",
				"luacheck",
				"spellcheck",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
				"goimports",
				"gofumpt",
				"gomodifytags",
				"impl",
				"delve",
				-- "ktlint",
			})
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = true },
			---@type lspconfig.options
			servers = {
				cssls = {},
				-- kotlin_language_server = {
				-- 	{
				-- 		cmd = { "kotlin-language-server" },
				-- 		filetypes = { "kotlin" },
				-- 		root_dir = lspconfig.util.root_pattern(
				-- 			"settings.gradle",
				-- 			"settings.gradle.kts",
				-- 			"build.gradle",
				-- 			"build.gradle.kts",
				-- 			".git"
				-- 		),
				-- 		settings = {
				-- 			kotlin = {
				-- 				compiler = {
				-- 					jvm = {
				-- 						target = "1.8",
				-- 					},
				-- 				},
				-- 			},
				-- 		},
				-- 	},
				-- },
				tailwindcss = {
					filetypes_exclude = { "markdown" },
					-- add additional filetypes to the default_config
					filetypes_include = {},
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
				},
				tsserver = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				html = {},
				lua_ls = {
					-- enabled = false,
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {
									-- "--log-level=trace",
								},
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
			},
			setup = {
				tailwindcss = function(_, opts)
					local tw = require("lspconfig.server_configurations.tailwindcss")
					opts.filetypes = opts.filetypes or {}

					-- Add default filetypes
					vim.list_extend(opts.filetypes, tw.default_config.filetypes)

					-- Remove excluded filetypes
					--- @param ft string
					opts.filetypes = vim.tbl_filter(function(ft)
						return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
					end, opts.filetypes)

					-- Add additional filetypes
					vim.list_extend(opts.filetypes, opts.filetypes_include or {})
				end,
			},
		},
	},
	{
		"nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
		},
		opts = function(_, opts)
			-- original LazyVim kind icon formatter
			local format_kinds = opts.formatting.format
			opts.formatting.format = function(entry, item)
				format_kinds(entry, item) -- add icons
				return require("tailwindcss-colorizer-cmp").formatter(entry, item)
			end
		end,
	},
	{ "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					keys = {
						-- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
						{ "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
					},
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
			},
			setup = {
				gopls = function(_, opts)
					-- workaround for gopls not supporting semanticTokensProvider
					-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
					LazyVim.lsp.on_attach(function(client, _)
						if not client.server_capabilities.semanticTokensProvider then
							local semantic = client.config.capabilities.textDocument.semanticTokens
							client.server_capabilities.semanticTokensProvider = {
								full = true,
								legend = {
									tokenTypes = semantic.tokenTypes,
									tokenModifiers = semantic.tokenModifiers,
								},
								range = true,
							}
						end
					end, "gopls")
					-- end workaround
				end,
			},
		},
	},
}
