vim.api.nvim_create_autocmd("VimEnter", {
	group = alacrittyAutoGroup,
	callback = function()
		vim.fn.system(
			"alacritty msg --socket $ALACRITTY_SOCKET config -w $ALACRITTY_WINDOW_ID options 'window.padding.x=0' 'window.padding.y=0' 'window.dynamic_padding=false'"
		)
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = alacrittyAutoGroup,
	callback = function()
		vim.fn.jobstart("alacritty msg --socket $ALACRITTY_SOCKET config -w $ALACRITTY_WINDOW_ID -r", { detach = true })
	end,
})
