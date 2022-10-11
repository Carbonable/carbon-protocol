import yaml
from pathlib import Path

from mdutils.mdutils import MdUtils


class Document():

    swagger_open = '{{% swagger method = "{method}" path = " " baseUrl = " " summary = "{name}" %}}'
    swagger_close = '{% endswagger %}'
    swagger_description_open = '{% swagger-description %}'
    swagger_description_close = '{% endswagger-description %}'
    swagger_parameter_open = '{{% swagger-parameter in="path" type="{argtype}" name="{name}" %}}'
    swagger_parameter_close = '{% endswagger-parameter %}'
    swagger_response_open = '{{% swagger-response status="{name}" description="{description}" %}}'
    swagger_response_close = '{% endswagger-response %}'

    prettier = {
        "storage_var": "storage",
        "namespace": "internal",
    }

    def __init__(self, root: Path, name: str, header: str, data: dict) -> None:
        self._root = root
        self._name = name
        self._header = header
        self._data = data

        self._functions = {}
        self._functions.update(self.constructors)
        self._functions.update(self.views)
        self._functions.update(self.externals)
        self._functions.update(self.events)
        # self._functions.update(self.storages)
        # self._functions.update(self.internals)

    @classmethod
    def from_yaml(cls, root, path):
        name = path.stem
        header = f"Carbonable {name.capitalize()}"
        with open(path.with_suffix(".yaml"), "r") as yamlpath:
            data = yaml.safe_load(yamlpath)
        return cls(root / path.parent.name, name, header, data)

    @staticmethod
    def filter(data, key):
        keyword = Document.prettier.get(key, key)
        return {
            keyword: [
                func
                for func in data
                if func.get("attributeName").startswith(key)
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

    @property
    def events(self):
        functype = "event"
        return self.filter(self._data, functype)

    @property
    def storages(self):
        functype = "storage_var"
        return self.filter(self._data, functype)

    @property
    def internals(self):
        functype = "namespace"
        return self.filter(self._data, functype)

    def create_api_page(self):
        for functype, functions in self._functions.items():
            if not functions:
                continue

            filepath = self._root / functype
            markdown = MdUtils(file_name=filepath.as_posix(),
                               title=functype.capitalize())

            for function in functions:
                function_name = function.get("functionName")
                function_signature = function.get("functionSignature")
                function_comment = function.get("functionComment")
                self.add_function(
                    markdown,
                    functype,
                    function_name,
                    function_signature,
                    function_comment
                )

            markdown.create_md_file()

    def add_function(self, markdown, functype, function_name, function_signature, function_comment):
        name = function_name.get("name")

        descriptions = function_comment.get("desc") or []
        description = " ".join(desc.get("desc") for desc in descriptions)

        markdown.new_line(Document.swagger_open.format(
            method=functype.replace("o", "0"), name=name))

        markdown.new_line(Document.swagger_description_open)
        markdown.new_line(description)
        markdown.new_line(Document.swagger_description_close)

        for method, args in function_signature.items():
            # hide implicit arguments
            if args is None or method.startswith("implicit"):
                continue

            # remove empty names
            args = [arg for arg in args if arg.get("name")]

            argcoms = {
                arg.get("name"): arg
                for arg in (function_comment.get(method) or [])
            }

            for arg in args:
                arg.update(argcoms.get(arg.get('name'), {}))
                argtype = arg.get('type')
                argdesc = arg.get('desc', '')
                argname = arg.get('name')

                # returns
                if "return" in method.lower():
                    argstr = f"{argname} ( {argtype} )"
                    markdown.new_line(Document.swagger_response_open.format(
                        name=argstr, description=argdesc))
                    # markdown.new_line(example)  # TODO: add example
                    markdown.new_line(Document.swagger_response_close)
                    continue

                # implicit / explicit args
                markdown.new_line(Document.swagger_parameter_open.format(
                    argtype=argtype, name=argname))
                markdown.new_line(argdesc)
                markdown.new_line(Document.swagger_parameter_close)

        markdown.new_line(Document.swagger_close)


root = Path(__file__).parent
for path in root.glob("**/*.yaml"):
    document = Document.from_yaml(root, path)
    document.create_api_page()
