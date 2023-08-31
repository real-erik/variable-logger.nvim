test: test_

test_:
	nvim --headless -c "PlenaryBustedFile lua/variable-logger/init.test.lua"

watch:
	watchexec -w lua just test_
