-- Ce script vise à normaliser la longueur des lignes dans le buffer courant
-- en ajoutant des espaces à la fin de chaque ligne si nécessaire, pour
-- qu'elles aient toutes une longueur maximale de max_length. Cette
-- normalisation est effectuée tout en maintenant le caractère '|' à la fin
-- fin de chaque ligne si présent initialement.
--
-- Si la longueur max_length de la ligne lue est déjà atteintei le traitement
-- n'est pas appliqué à la ligne

max_length = 110

for line_num = 1, vim.fn.line('$') do
    local line = vim.fn.getline(line_num)
    local line_length = vim.fn.strdisplaywidth(line)
    if line_length < max_length then
        local nl = line

        if string.sub(line, -1) == '|' then
            nl = string.sub(line, 1, -2) 
        end

        pad_length = max_length - line_length
        nl = nl .. string.rep(' ', pad_length) .. '|'
        vim.fn.setline(line_num, nl)
    end
end

