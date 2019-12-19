ObjectBox Examples
==========================

In the following file, e.g. `models.dart`, we import objectbox.dart to get definitions for `@Entity`, 
`@Id` and other annotations and define a single entity that should be persisted by ObjectBox. You could have multiple 
entities in the same file or you can have them spread across multiple files in the `lib` directory tree. 

```dart
import "package:objectbox/objectbox.dart";

@Entity()
class Note {
    @Id()       // required; stored as a 64-bit unsigned integer in ObjectBox
    int id;
    String text;
    
    Note({this.text}); // empty default constructor needed but it can have optional args
    toString() => "Note{id: $id, text: $text}";
}
```

ObjectBox generator will look for all `@Entity` annotations in your `lib` folder and create a single database definition
`lib/objectbox-model.json` and supporting code in `lib/objectbox.g.dart`. 
You should commit `objectbox-model.json` into your source control (e.g. git) and add `objectbox.g.dart` to the ignore 
list (e.g. .gitignore), otherwise the build_runner will complain about it being changed each time you pull a change.

Note: the generator will process `lib` and `test` folders separately and create a separate database in each one, if it 
finds annotations there. This is useful if you need a separate test DB, but if you're just writing tests for your own 
code you won't have any annotations in the `test` folder so no DB will be created there.  

-------------------

To use ObjectBox and store the just defined entity, you should import `objectbox.g.dart` and create the `Store`.
Finally, you will create a `Box<Note>` which gives you a typed interface for storing and retrieving `Note` objects.

```dart
import 'objectbox.g.dart'; // this file will be generated by ObjectBox after running `pub run build_runner build`

void main() {
    var store = Store(getObjectBoxModel()); // Note: getObjectBoxModel() is generated for you in objectbox.g.dart
    var box = Box<Note>(store);
    
    var note = Note(text: "Hello");
    note.id = box.put(note);
    print("new note got id ${note.id}");
    print("refetched note: ${box.get(note.id)}");
    
    store.close();
}
```

See also
--------
* sample [Flutter android app](flutter/objectbox_demo) - requires Flutter 1.12 