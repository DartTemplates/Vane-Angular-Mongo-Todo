part of todo;

// Backend class that communicates with the backend and hold the items list
@Injectable()
class ItemsBackend {
//  Http _http2;
  BrowserClient _http = new BrowserClient();
  List<Item> data = [];
  String _baseUrl;

//  ItemsBackend(this._http) {
  ItemsBackend() {
    // Initialize baseUrl (9090 for during development locally, otherwise use
    // standard port 80 for production)
    Uri uri = Uri.parse(window.location.href);
    var port = uri.port != 8080 ? 80 : 9090;
    _baseUrl = 'http://${uri.host}:${port}';
  }

  void getAll() {
    // Make request to get a list of all todo items
    _http.get('${_baseUrl}/todos').then((res) {
      var json = JSON.decode(res.body);

      json.forEach((item) {
        data.add(new Item.fromJson(item));
      });
    });
  }

  void add(Item item) {
    print("In backend.add");

    // Add new item to list, instant change in UI
    data.add(item);

    print("Body: ${JSON.encode(item)}");

    // Make request to add new item to database
    _http.post("${_baseUrl}/todos",
               body: JSON.encode(item),
               headers: {'Content-Type': 'application/json'}).then((res) {
      // If there were an error, remove it from the list
      if(res.statusCode != 200) {
        data.removeWhere((i) => i.id == item.id);
      }
    }).catchError((error) {
      print("Got error $error");

      // If there were an error, remove it from the list
      data.removeWhere((i) => i.id == item.id);
    });
  }

  void update(int index) {
    print("In backend.update");

    // Make request to update archive property in database
    _http.put("${_baseUrl}/todos", body: JSON.encode(data[index])).then((res) {
      // If action was not successfull, reset item's state
      if(res.statusCode == 200) {
        print("Item has been updated");
      } else {
        print("There was an error updating the item");
      }
    }).catchError((error) {
      print("Got error $error");
    });
  }

  void delete(int index) {
    print("In backend.delete");

    // Save a copy of item in case action fails
    var item = data[index];

    // Remove item instantly in UI
    data.removeAt(index);

    // Make request to delete item
    _http.delete("${_baseUrl}/todos/${item.id}").then((res) {
      // If action was not successfull, put back item into list again
      if(res.statusCode != 200) {
        data.insert(index, item);
      }
    }).catchError((error) {
      print("Got error $error");

      // If there was an error, put back the item into list again
      data.insert(index, item);
    });
  }
}

