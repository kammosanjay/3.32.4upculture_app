class ArtistDetailRequest {
  int? artistId;

  ArtistDetailRequest({this.artistId});

  ArtistDetailRequest.fromJson(Map<String, dynamic> json) {
    artistId = json['artist_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['artist_id'] = artistId;
    return data;
  }
}
