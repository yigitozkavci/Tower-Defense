A = "Helloivit"
local file, err = io.open ('test.txt',"a")
if file==nil then
    print("Couldn't open file: "..err)
else
    file:write(A)
    file:close()
end