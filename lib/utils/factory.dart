import 'package:eng_soft_contacts_list/ui/data/contact.dart';
import 'package:eng_soft_contacts_list/ui/data/group.dart';

createClassAccordingToType(String classType) {
  if (classType == "Contact") {
    var contact = Contact();
    return contact;
  } else if (classType == "Group") {
    var group = Group();
    return group;
  }
}
