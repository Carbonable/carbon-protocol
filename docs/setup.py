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

    file_name = root / contract / "index"
    if file_name.exists():
        file_name.unlink()

    markdown = MdUtils(file_name=file_name.as_posix())

    markdown.new_header(level=1, title="Introduction")
    markdown.new_paragraph("This is an introduction")
    markdown.new_paragraph()

    markdown.new_header(level=1, title="Description")
    markdown.new_paragraph("This is a description")
    markdown.new_paragraph()

    markdown.new_header(level=1, title="API Documentation")

    for function in document:
        attribute_name = function.get("attributeName")
        function_name = function.get("functionName")
        function_signature = function.get("functionSignature")
        function_comment = function.get("functionComment")

        title = f"{contract}.{function_name.get('name')}"
        descriptions = function_comment.get("desc") or []
        description = '  '.join(
            [info.get("desc") for info in descriptions]
        ) or ''

        markdown.new_header(level=2, title=function_name.get("name"))
        markdown.new_paragraph(description)
        markdown.new_paragraph()

        for argtype, args in function_signature.items():
            markdown.new_header(level=3, title=argtype)
            if args is None:
                args = {}

            for arg in args:

                argtype = arg.get('type')
                typestr = f"({argtype})" if argtype else ''
                markdown.new_line(f"  - {arg.get('name')}{typestr}")

            markdown.new_paragraph()

    markdown.create_md_file()
