AbstractTrees.children(x::AbstractXMLNode) = collect(child_elements(x));
AbstractTrees.printnode(io::IO, x::AbstractXMLNode) = print(io, name(x));

#Processes XML codebook tree into a usable JSON table
function process_codebook()
    xdoc = parse_file("PSIDCodebook.xml");
    r = root(xdoc);
    t = Tree(r)
    # Travel down the tree until we reach the list of variables
    name(t[1])
    current_node = children(r)[1]
    name(current_node)
    current_node = children(current_node)[1]
    name(current_node)
    current_node = children(current_node)[2]
    name(current_node)
    ce = current_node["VARIABLE"]
    # Ingest the variables into a DataFrame
    outdf = DataFrame()
    outdf.NAME =  [content(ce[i]["NAME"][1]) for i in 1:length(ce)]
    outdf.YEAR =  [content(ce[i]["YEAR"][1]) for i in 1:length(ce)]
    outdf.QTEXT =  [content(ce[i]["QTEXT"][1]) for i in 1:length(ce)]
    outdf.ETEXT =  [content(ce[i]["ETEXT"][1]) for i in 1:length(ce)]
    outdf.TYPE_ID =  [content(ce[i]["TYPE_ID"][1]) for i in 1:length(ce)]
    outdf.LABEL =  [content(ce[i]["LABEL"][1]) for i in 1:length(ce)]


    # codes
    list_codes = [ce[i]["LIST_CODE"][1] for i in 1:length(ce)]

    list_codes[1]

    # Take a codexml vector of some length containing (value, text) pairs
    # Return a dict
    function process_codes(codexml)
        codes = codexml["CODE"]
        vals = [content(c["VALUE"][1]) for c in codes]
        texts = [content(c["TEXT"][1]) for c in codes]
        Dict(v => t for (v, t) in zip(vals, texts))
    end
    process_codes(list_codes[1])

    morecodes = process_codes.(list_codes)
    outdf.codedict = morecodes

    #j = objecttable(outdf)
    j = arraytable(outdf)
    write("output/codebook.json", j)
end
