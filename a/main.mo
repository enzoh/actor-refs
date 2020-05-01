import Iter "mo:stdlib/iter";
import List "mo:stdlib/list";
import Option "mo:stdlib/option";

actor {

    private type CanisterId = Text;

    private type List<T> = List.List<T>;

    private var registry = List.nil<CanisterId>();

    public query func dump() : async List<CanisterId> {
        return registry;
    };

    public func register(canisterId : CanisterId) {
        registry := List.push(canisterId, registry);
    };

    public func get(key : Text) : async ?Text {
        for (canisterId in Iter.fromList<CanisterId>(registry)) {
            let shard = actor (canisterId) : actor {
                get(key : Text) : async ?Text
            };
            let result = await shard.get(key);
            if (Option.isSome(result)) {
                return ?Option.unwrap<Text>(result);
            };
        };
        return null;
    };

    public func put(key : Text, value : Text) : async Bool {
        for (canisterId in Iter.fromList<CanisterId>(registry)) {
            let shard = actor (canisterId) : actor {
                put(key : Text, value : Text) : async Bool
            };
            let success = await shard.put(key, value);
            if (success) {
                return success;
            };
        };
        return false;
    };
};
