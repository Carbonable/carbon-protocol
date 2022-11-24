import yaml
from pathlib import Path
from starkware.crypto.signature.fast_pedersen_hash import pedersen_hash


class Object():
    pass


def update(ref: dict, new: dict) -> dict:
    """Update ref recursively with new."""
    for key, value in new.items():
        if isinstance(value, dict):
            ref[key] = update(ref.get(key, {}), value)
        else:
            ref[key] = value
    return ref


def objectify(parent: object, attributes: dict) -> object:
    """Set attributes recursively to parent object."""
    for key, value in attributes.items():
        if isinstance(value, dict):
            value = objectify(Object(), value)
        setattr(parent, key, value)
    return parent


def load(path: str, context: object):
    """Read config files and setup context."""
    # load config
    path = Path(path)
    config = {}
    for parent in reversed(path.parents):
        config_path = parent / path.name
        if not config_path.exists():
            continue
        with open(config_path, 'r') as file_instance:
            update(config, yaml.safe_load(file_instance))

    # set up context
    context = objectify(context, config)


class MerkleTree:

    @staticmethod
    def get_next_level(level):
        next_level = []
        for i in range(0, len(level), 2):
            node = 0
            if level[i] < level[i + 1]:
                node = pedersen_hash(level[i], level[i + 1])
            else:
                node = pedersen_hash(level[i + 1], level[i])
            next_level.append(node)
        return next_level

    @staticmethod
    def generate_proof_helper(level, index, proof):
        if len(level) == 1:
            return proof
        if len(level) % 2 != 0:
            level.append(0)
        next_level = MerkleTree.get_next_level(level)
        index_parent = 0
        for i in range(0, len(level)):
            if i == index:
                index_parent = i // 2
                if i % 2 == 0:
                    proof.append(level[index + 1])
                else:
                    proof.append(level[index - 1])
        return MerkleTree.generate_proof_helper(next_level, index_parent, proof)

    @staticmethod
    def generate_merkle_proof(values, index):
        return MerkleTree.generate_proof_helper(values, index, [])

    @staticmethod
    def generate_merkle_root(values):
        if len(values) == 1:
            return values[0]
        if len(values) % 2 != 0:
            values.append(0)
        next_level = MerkleTree.get_next_level(values)
        return MerkleTree.generate_merkle_root(next_level)

    @staticmethod
    def get_leaf(recipient, amount):
        leaf = pedersen_hash(recipient, amount)
        return leaf

    @staticmethod
    def get_leaves(recipients, amounts):
        values = []
        for recipient, amount in zip(recipients, amounts):
            leaf = MerkleTree.get_leaf(recipient, amount)
            values.append(leaf)
        if len(values) % 2:
            values.append(0)
        return values
