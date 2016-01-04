contract SimpleStorage {
  string32 data;

  function set(string32 value) {
    data = value;
  }

  function get() constant returns (string32 value){
    return data;
  }
}
