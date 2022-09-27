import yaml
from pathlib import Path

from mdutils.mdutils import MdUtils


class Document():

    def __init__(self, root: Path, name: str, header: str, data: dict) -> None:
        self._root = root
        self._name = name
        self._header = header
        self._data = data

        self._functions = {}
        self._functions.update(self.constructors)
        self._functions.update(self.views)
        self._functions.update(self.externals)

    @classmethod
    def from_yaml(cls, root, path):
        name = path.stem
        header = f"Carbonable {name.capitalize()}"
        with open(path.with_suffix(".yaml"), "r") as yamlpath:
            data = yaml.safe_load(yamlpath)
        return cls(root, name, header, data)

    @staticmethod
    def filter(data, key):
        return {
            key: [
                func
                for func in data
                if func.get("attributeName") == key
            ]
        }

    @property
    def constructors(self):
        functype = "constructor"
        return self.filter(self._data, functype)

    @property
    def views(self):
        functype = "view"
        return self.filter(self._data, functype)

    @property
    def externals(self):
        functype = "external"
        return self.filter(self._data, functype)

    def create_description(self, description):
        filepath = self._root / self._name / "index"
        markdown = MdUtils(file_name=filepath.as_posix())
        markdown.new_header(level=1, title=self._header)
        markdown.new_paragraph(description)
        markdown.new_paragraph()
        markdown.create_md_file()

    def create_api_page(self):
        for functype, functions in self._functions.items():
            filepath = self._root / self._name / functype
            markdown = MdUtils(file_name=filepath.as_posix(),
                               title=functype.capitalize())

            for function in functions:
                function_name = function.get("functionName")
                function_signature = function.get("functionSignature")
                function_comment = function.get("functionComment")
                self.add_function(
                    markdown,
                    function_name,
                    function_signature,
                    function_comment
                )

            markdown.create_md_file()

    def add_function(self, markdown, function_name, function_signature, function_comment):
        name = function_name.get("name")

        markdown.new_line("<details>\n")
        markdown.new_line(f"<summary>{name}</summary>")

        descriptions = function_comment.get("desc") or []
        description = "  ".join(desc.get("desc") for desc in descriptions)
        markdown.new_paragraph(description)

        for argtype, args in function_signature.items():
            title = argtype.replace('Args', ' args').capitalize()
            markdown.new_line()
            markdown.new_line(title, bold_italics_code="b")

            argcoms = {
                arg.get("name"): arg
                for arg in (function_comment.get(argtype) or [])
            }

            if args is None:
                args = {}

            codes = []
            for arg in args:
                arg.update(argcoms.get(arg.get('name'), {}))
                argname = arg.get('name')
                argtype = arg.get('type')
                argdesc = arg.get('desc', '')
                typestr = f"({argtype})" if argtype else ''
                codes.append(f"{argname}{typestr}: {argdesc}")
            code_block = "\n".join(codes)
            markdown.insert_code(code_block, language="rust")

        markdown.new_line("</details>\n")


root = Path(__file__).parent
for path in root.glob("**/*.yaml"):
    document = Document.from_yaml(root, path)
    document.create_description("This is a description")
    document.create_api_page()
