function create_lookup_map(pieces_array) {
    var lookup_map = ds_map_create();
    for (var i = 0; i < array_length(pieces_array); i++) {
        var piece = pieces_array[i];
        ds_map_set(lookup_map, piece.tag, piece);
    }
    return lookup_map;
}