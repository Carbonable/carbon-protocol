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

        markdown.new_line('{% tabs %}')

        for argtype, args in function_signature.items():
            #markdown.new_header(level=3, title=argtype)
            title = argtype.replace('Args', ' args').capitalize()
            markdown.new_line(f'{{% tab title="{title}" %}}')

            if args is None:
                args = {}

            codes = []
            for arg in args:
                argtype = arg.get('type')
                typestr = f"({argtype})" if argtype else ''
                codes.append(f"{arg.get('name')}{typestr}")
            code_block = "\n".join(codes)

            markdown.insert_code(code_block, language="cairo")
            markdown.new_line('{% endtab %}')

        markdown.new_line('{% endtabs %}')
        markdown.new_paragraph()

    markdown.create_md_file()
