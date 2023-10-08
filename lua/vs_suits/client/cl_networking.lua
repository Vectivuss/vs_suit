
net.Receive( "vs.suits", function()
    local l = net.ReadUInt(12)
    local data = util.Decompress(net.ReadData(l))
    if data != nil then VectivusSuits.Suits = util.JSONToTable(data) end
    local l = net.ReadUInt(12)
    local data = util.Decompress(net.ReadData(l))
    if data != nil then VectivusSuits.Abilities = util.JSONToTable(data) end
    VectivusSuits.GenerateSuits()
end )
