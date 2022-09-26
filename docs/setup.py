import yaml
from pathlib import Path

from mdutils.mdutils import MdUtils

root = Path(".")
path = root / "data"
documents = {}
for filepath in path.glob("**/*.yaml"):
    print(filepath)
    with open(filepath, "r") as yamlpath:
        documents.setdefault(filepath.stem, yaml.safe_load(yamlpath))


for (contract, document) in documents.items():

    file_name = (root / contract / contract).as_posix()
    mdFile = MdUtils(
        file_name=file_name,
        title=contract.capitalize(),
    )

    for function in document:
        attribute_name = function.get("attributeName")
        function_name = function.get("functionName")
        function_signature = function.get("functionSignature")
        function_comment = function.get("functionComment")

        title = f"{contract}.{function_name.get('name')}"

        mdFile.new_header(level=1, title=title)

    mdFile.create_md_file()
