contract ContactForm {

  uint contacts_count;

  struct Contact {
    bytes32 first;
    bytes32 last;
  }

  mapping(bytes32 => Contact) contacts;

  function addContact(bytes32 email, bytes32 first, bytes32 last) {
    Contact contact = contacts[email];
    if (contact.first != "") {
      return;
    }

    contact.first = first;
    contact.last = last;
    contacts_count++;
  }

  function getFirst(bytes32 email) constant returns (bytes32) {
    return contacts[email].first;
  }

  function getLast(bytes32 email) constant returns (bytes32) {
    return contacts[email].last;
  }

  function getContactCount() constant returns (uint) {
    return contacts_count;
  }

  function remove() {
    suicide(msg.sender);
  }

}
