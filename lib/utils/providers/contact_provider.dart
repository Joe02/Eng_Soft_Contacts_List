import 'package:eng_soft_contacts_list/ui/data/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ContactProvider with ChangeNotifier, DiagnosticableTreeMixin {

  late Contact globalContact;

}