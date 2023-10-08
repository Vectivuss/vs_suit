
--[[------------------------------------------
    @ Lib       » Sanitizer
    @ Author    » Vectivus, inspiration by <SLAUGH7ER>
--------------------------------------------]]

VectivusLib = VectivusLib or {}

function VectivusLib:SanitizeTable( tbl )
    local t = {}
    for k, v in pairs( table.Copy( tbl or {} ) ) do
        for kk, vv in pairs( v ) do
            t[k] = t[k] or {}
            t[k][kk] = TypeID( vv ) != TYPE_FUNCTION and vv or nil
            for kkk, vvv in pairs( istable( vv ) and vv or {} ) do
                t[k][kk][kkk] = TypeID( vvv ) != TYPE_FUNCTION and vvv or nil
            end
        end
    end
    return t
end
