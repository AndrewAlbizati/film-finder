Uri getUrl(String path) {
  var host = "localhost";
  var port = 8000;

  return Uri(scheme: "http", host: host, port: port, path: path);
}
