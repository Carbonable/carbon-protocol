import yaml
from pathlib import Path

from mdutils.mdutils import MdUtils


class Document():

    swagger_open = '{{% swagger method = "{method}" path = " " baseUrl = " " summary = "{name}" %}}'
    swagger_close = '{% endswagger %}'
    swagger_description_open = '{% swagger-description %}'
    swagger_description_close = '{% endswagger-description %}'
    swagger_parameter_open = '{{% swagger-parameter in="path" type="{scope}" required="{required}" name="{name}" %}}'
    swagger_parameter_close = '{% endswagger-parameter %}'
    swagger_response_open = '{{% swagger-response status="{name}" description="{description}" %}}'
    swagger_response_close = '{% endswagger-response %}'

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
                attribute_name = function.get("attributeName")
                function_name = function.get("functionName")
                function_signature = function.get("functionSignature")
                function_comment = function.get("functionComment")
                self.add_function(
                    markdown,
                    attribute_name,
                    function_name,
                    function_signature,
                    function_comment
                )

            markdown.create_md_file()

    def add_function(self, markdown, attribute_name, function_name, function_signature, function_comment):
        name = function_name.get("name")

        descriptions = function_comment.get("desc") or []
        description = " ".join(desc.get("desc") for desc in descriptions)

        markdown.new_line(Document.swagger_open.format(
            method=attribute_name.replace("o", "0"), name=name))

        markdown.new_line(Document.swagger_description_open)
        markdown.new_line(description)
        markdown.new_line(Document.swagger_description_close)

        for method, args in function_signature.items():
            if args is None:
                continue

            argcoms = {
                arg.get("name"): arg
                for arg in (function_comment.get(method) or [])
            }
            argscope = f"{{{method.replace('Args', '')}}}"

            for arg in args:
                arg.update(argcoms.get(arg.get('name'), {}))
                argtype = arg.get('type')
                argdesc = arg.get('desc', '')
                typestr = f"({argtype})" if argtype else ''
                argname = f"{arg.get('name')}{typestr}"

                # returns
                if "return" in argscope:
                    markdown.new_line(Document.swagger_response_open.format(
                        name=argname, description=argdesc))
                    # markdown.new_line(example)  # TODO: add example
                    markdown.new_line(Document.swagger_response_close)
                    continue

                # implicit / explicit args
                required = "explicit" in argscope
                markdown.new_line(Document.swagger_parameter_open.format(
                    scope=argscope, required=required, name=argname))
                markdown.new_line(argdesc)
                markdown.new_line(Document.swagger_parameter_close)

        markdown.new_line(Document.swagger_close)


root = Path(__file__).parent
for path in root.glob("**/*.yaml"):
    document = Document.from_yaml(root, path)
    document.create_description("This is a description")
    document.create_api_page()
