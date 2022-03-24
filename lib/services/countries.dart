part of "package:baso/baso.dart";

class CountriesService {
  static List<Map<String, String>> countries = <Map<String, String>>[];

  static Future<List<Map<String, String>>> getCountries() async {
    if (countries.isNotEmpty) {
      return countries;
    }

    try {
      var url =
          Uri.parse("http://www.geognos.com/api/en/countries/info/all.json");

      HTTP.Response response = await HTTP.get(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
      );

      Map tmp = jsonDecode(response.body)["Results"];

      countries = tmp.entries.map((entry) {
        final key = entry.key;
        final country = entry.value;

        String name = country["Name"] ?? "";
        String formatedName = removeDiacritics(name).toLowerCase();
        String code =
            country["TelPref"] == null ? "" : ("+" + country["TelPref"]);
        String flag = "http://www.geognos.com/api/en/countries/flag/$key.png";
        String section =
            formatedName.isEmpty ? "#" : formatedName.characters.first;

        return <String, String>{
          "name": name,
          "code": code,
          "flag": flag,
          "section": section,
          "formated_name": formatedName,
        };
      }).toList();

      countries.sort((a, b) {
        return (a["formated_name"] ?? "").compareTo(b["formated_name"] ?? "");
      });

      return countries;
    } catch (e) {
      print(e);
      return countries;
    }
  }
}
