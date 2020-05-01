import AssocList "mo:stdlib/assocList";
import Option "mo:stdlib/option";

actor {

    private type AssocList<K, V> = AssocList.AssocList<K, V>;

    private var count : Nat = 0;

    private let capacity : Nat = 3;

    private var db : AssocList<Text, Text> = null;

    private func eq(a : Text, b : Text) : Bool {
        return a == b;
    };

    public query func get(key : Text) : async ?Text {
        return AssocList.find<Text, Text>(db, key, eq);
    };

    public func put(key : Text, value : Text) : async Bool {
        let result = AssocList.replace<Text, Text>(db, key, eq, ?value);
        if (Option.isNull(result.1) and (count == capacity)) {
            return false;
        } else {
            db := result.0;
            count += 1;
            return true;
        };
    };
};
