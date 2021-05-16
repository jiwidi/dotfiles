function github -d "quick cd into github projects folder"
	cd ~/Documents/github/$argv
end

complete --command github --arguments '(__c_complete)'
