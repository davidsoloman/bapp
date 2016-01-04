contract SimpleStorage {
  bytes32 data;

  function set(bytes32 value) {
    data = value;
  }

  function get() constant returns (bytes32 value){
    return data;
  }
}
