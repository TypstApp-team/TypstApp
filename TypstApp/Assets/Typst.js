return {
    "name": "typst",
    "patterns": [
        {
            "include": "#markup"
        }
    ],
    "repository": {
        "comments": {
            "patterns": [
                {
                    "name": "comment.block.typst",
                    "begin": "/\\*",
                    "end": "\\*/",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.comment.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#comments"
                        }
                    ]
                },
                {
                    "name": "comment.line.double-slash.typst",
                    "begin": "(?<!:)//",
                    "end": "\n",
                    "beginCaptures": {
                        "0": {
                            "name": "punctuation.definition.comment.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#comments"
                        }
                    ]
                }
            ]
        },
        "common": {
            "patterns": [
                {
                    "include": "#comments"
                }
            ]
        },
        "markup": {
            "patterns": [
                {
                    "include": "#common"
                },
                {
                    "name": "constant.character.escape.content.typst",
                    "match": "\\\\([\\\\/\\[\\]{}#*_=~`$-.]|u\\{[0-9a-zA-Z]*\\}?)"
                },
                {
                    "name": "punctuation.definition.linebreak.typst",
                    "match": "\\\\"
                },
                {
                    "name": "punctuation.definition.nonbreaking-space.typst",
                    "match": "~"
                },
                {
                    "name": "punctuation.definition.shy.typst",
                    "match": "-\\?"
                },
                {
                    "name": "punctuation.definition.em-dash.typst",
                    "match": "---"
                },
                {
                    "name": "punctuation.definition.en-dash.typst",
                    "match": "--"
                },
                {
                    "name": "punctuation.definition.ellipsis.typst",
                    "match": "\\.\\.\\."
                },
                {
                    "name": "constant.symbol.typst",
                    "match": ":([a-zA-Z0-9]+:)+"
                },
                {
                    "name": "markup.bold.typst",
                    "begin": "(^\\*|\\*$|((?<=\\W|_)\\*)|(\\*(?=\\W|_)))",
                    "end": "(^\\*|\\*$|((?<=\\W|_)\\*)|(\\*(?=\\W|_)))|\n|(?=\\])",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.bold.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#markup"
                        }
                    ]
                },
                {
                    "name": "markup.italic.typst",
                    "begin": "(^_|_$|((?<=\\W|_)_)|(_(?=\\W|_)))",
                    "end": "(^_|_$|((?<=\\W|_)_)|(_(?=\\W|_)))|\n|(?=\\])",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.italic.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#markup"
                        }
                    ]
                },
                {
                    "name": "markup.underline.link.typst",
                    "match": "https?://[0-9a-zA-Z~/%#&=',;\\.\\+\\?]*"
                },
                {
                    "name": "markup.raw.block.typst",
                    "begin": "`{3,}",
                    "end": "\\0",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.raw.typst"
                        }
                    }
                },
                {
                    "name": "markup.raw.inline.typst",
                    "begin": "`",
                    "end": "`",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.raw.typst"
                        }
                    }
                },
                {
                    "name": "string.other.math.typst",
                    "begin": "\\$",
                    "end": "\\$",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.string.math.typst"
                        }
                    }
                },
                {
                    "name": "markup.heading.typst",
                    "contentName": "entity.name.section.typst",
                    "begin": "^\\s*=+\\s+",
                    "end": "\n|(?=<)",
                    "beginCaptures": {
                        "0": {
                            "name": "punctuation.definition.heading.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#markup"
                        }
                    ]
                },
                {
                    "name": "punctuation.definition.list.unnumbered.typst",
                    "match": "^\\s*-\\s+"
                },
                {
                    "name": "punctuation.definition.list.numbered.typst",
                    "match": "^\\s*([0-9]*\\.|\\+)\\s+"
                },
                {
                    "match": "^\\s*(/)\\s+([^:]*:)",
                    "captures": {
                        "1": {
                            "name": "punctuation.definition.list.description.typst"
                        },
                        "2": {
                            "name": "markup.list.term.typst"
                        }
                    }
                },
                {
                    "name": "entity.other.label.typst",
                    "match": "<[[:alpha:]_][[:alnum:]_-]*>",
                    "captures": {
                        "1": {
                            "name": "punctuation.definition.label.typst"
                        }
                    }
                },
                {
                    "name": "entity.other.reference.typst",
                    "match": "(@)[[:alpha:]_][[:alnum:]_-]*",
                    "captures": {
                        "1": {
                            "name": "punctuation.definition.reference.typst"
                        }
                    }
                },
                {
                    "begin": "(#)(let|set|show)\\b",
                    "end": "\n|(;)|(?=])",
                    "beginCaptures": {
                        "0": {
                            "name": "keyword.other.typst"
                        },
                        "1": {
                            "name": "punctuation.definition.keyword.typst"
                        }
                    },
                    "endCaptures": {
                        "1": {
                            "name": "punctuation.terminator.statement.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#code"
                        }
                    ]
                },
                {
                    "name": "keyword.other.typst",
                    "match": "(#)(as|in)\\b",
                    "captures": {
                        "1": {
                            "name": "punctuation.definition.keyword.typst"
                        }
                    }
                },
                {
                    "begin": "((#)if|(?<=(}|])\\s*)else)\\b",
                    "end": "\n|(?=])|(?<=}|])",
                    "beginCaptures": {
                        "0": {
                            "name": "keyword.control.conditional.typst"
                        },
                        "2": {
                            "name": "punctuation.definition.keyword.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#code"
                        }
                    ]
                },
                {
                    "begin": "(#)(for|while)\\b",
                    "end": "\n|(?=])|(?<=}|])",
                    "beginCaptures": {
                        "0": {
                            "name": "keyword.control.loop.typst"
                        },
                        "1": {
                            "name": "punctuation.definition.keyword.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#code"
                        }
                    ]
                },
                {
                    "name": "keyword.control.loop.typst",
                    "match": "(#)(break|continue)\\b",
                    "captures": {
                        "1": {
                            "name": "punctuation.definition.keyword.typst"
                        }
                    }
                },
                {
                    "begin": "(#)(import|include|export)\\b",
                    "end": "\n|(;)|(?=])",
                    "beginCaptures": {
                        "0": {
                            "name": "keyword.control.import.typst"
                        },
                        "1": {
                            "name": "punctuation.definition.keyword.typst"
                        }
                    },
                    "endCaptures": {
                        "1": {
                            "name": "punctuation.terminator.statement.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#code"
                        }
                    ]
                },
                {
                    "name": "keyword.control.flow.typst",
                    "match": "(#)(return)\\b",
                    "captures": {
                        "1": {
                            "name": "punctuation.definition.keyword.typst"
                        }
                    }
                },
                {
                    "comment": "Function name",
                    "name": "entity.name.function.typst",
                    "match": "((#)[[:alpha:]_][[:alnum:]_-]*!?)(?=\\[|\\()",
                    "captures": {
                        "2": {
                            "name": "punctuation.definition.function.typst"
                        }
                    }
                },
                {
                    "comment": "Function arguments",
                    "begin": "(?<=#[[:alpha:]_][[:alnum:]_-]*!?)\\(",
                    "end": "\\)",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.group.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#arguments"
                        }
                    ]
                },
                {
                    "name": "entity.other.interpolated.typst",
                    "match": "(#)[[:alpha:]_][.[:alnum:]_-]*",
                    "captures": {
                        "1": {
                            "name": "punctuation.definition.variable.typst"
                        }
                    }
                },
                {
                    "name": "meta.block.content.typst",
                    "begin": "#",
                    "end": "\\s",
                    "patterns": [
                        {
                            "include": "#code"
                        }
                    ]
                }
            ]
        },
        "code": {
            "patterns": [
                {
                    "include": "#common"
                },
                {
                    "name": "meta.block.code.typst",
                    "begin": "{",
                    "end": "}",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.block.code.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#code"
                        }
                    ]
                },
                {
                    "name": "meta.block.content.typst",
                    "begin": "\\[",
                    "end": "\\]",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.block.content.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#markup"
                        }
                    ]
                },
                {
                    "name": "comment.line.double-slash.typst",
                    "begin": "//",
                    "end": "\n",
                    "beginCaptures": {
                        "0": {
                            "name": "punctuation.definition.comment.typst"
                        }
                    }
                },
                {
                    "name": "punctuation.separator.colon.typst",
                    "match": ":"
                },
                {
                    "name": "punctuation.separator.comma.typst",
                    "match": ","
                },
                {
                    "name": "keyword.operator.typst",
                    "match": "=>|\\.\\."
                },
                {
                    "name": "keyword.operator.relational.typst",
                    "match": "==|!=|<=|<|>=|>"
                },
                {
                    "name": "keyword.operator.assignment.typst",
                    "match": "\\+=|-=|\\*=|/=|="
                },
                {
                    "name": "keyword.operator.arithmetic.typst",
                    "match": "\\+|\\*|/|(?<![[:alpha:]_][[:alnum:]_-]*)-(?![:alnum:]_-]*[[:alpha:]_])"
                },
                {
                    "name": "keyword.operator.word.typst",
                    "match": "\\b(and|or|not)\\b"
                },
                {
                    "name": "keyword.other.typst",
                    "match": "\\b(let|as|in|set|show)\\b"
                },
                {
                    "name": "keyword.control.conditional.typst",
                    "match": "\\b(if|else)\\b"
                },
                {
                    "name": "keyword.control.loop.typst",
                    "match": "\\b(for|while|break|continue)\\b"
                },
                {
                    "name": "keyword.control.import.typst",
                    "match": "\\b(import|include|export)\\b"
                },
                {
                    "name": "keyword.control.flow.typst",
                    "match": "\\b(return)\\b"
                },
                {
                    "include": "#constants"
                },
                {
                    "comment": "Function name",
                    "name": "entity.name.function.typst",
                    "match": "\\b[[:alpha:]_][[:alnum:]_-]*!?(?=\\[|\\()"
                },
                {
                    "comment": "Function name",
                    "name": "entity.name.function.typst",
                    "match": "(?<=\\bshow\\s*)\\b[[:alpha:]_][[:alnum:]_-]*(?=\\s*[:.])"
                },
                {
                    "comment": "Function arguments",
                    "begin": "(?<=\\b[[:alpha:]_][[:alnum:]_-]*!?)\\(",
                    "end": "\\)",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.group.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#arguments"
                        }
                    ]
                },
                {
                    "name": "variable.other.typst",
                    "match": "\\b[[:alpha:]_][[:alnum:]_-]*\\b"
                },
                {
                    "name": "meta.group.typst",
                    "begin": "\\(",
                    "end": "\\)|(?=;)",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.group.typst"
                        }
                    },
                    "patterns": [
                        {
                            "include": "#code"
                        }
                    ]
                }
            ]
        },
        "constants": {
            "patterns": [
                {
                    "name": "constant.language.none.typst",
                    "match": "\\bnone\\b"
                },
                {
                    "name": "constant.language.auto.typst",
                    "match": "\\bauto\\b"
                },
                {
                    "name": "constant.language.boolean.typst",
                    "match": "\\b(true|false)\\b"
                },
                {
                    "name": "constant.numeric.length.typst",
                    "match": "\\b(\\d*)?\\.?\\d+([eE][+-]?\\d+)?(mm|pt|cm|in|em)\\b"
                },
                {
                    "name": "constant.numeric.angle.typst",
                    "match": "\\b(\\d*)?\\.?\\d+([eE][+-]?\\d+)?(rad|deg)\\b"
                },
                {
                    "name": "constant.numeric.percentage.typst",
                    "match": "\\b(\\d*)?\\.?\\d+([eE][+-]?\\d+)?%"
                },
                {
                    "name": "constant.numeric.fr.typst",
                    "match": "\\b(\\d*)?\\.?\\d+([eE][+-]?\\d+)?fr"
                },
                {
                    "name": "constant.numeric.integer.typst",
                    "match": "\\b\\d+\\b"
                },
                {
                    "name": "constant.numeric.float.typst",
                    "match": "\\b(\\d*)?\\.?\\d+([eE][+-]?\\d+)?\\b"
                },
                {
                    "name": "string.quoted.double.typst",
                    "begin": "\"",
                    "end": "\"",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.string.typst"
                        }
                    },
                    "patterns": [
                        {
                            "name": "constant.character.escape.string.typst",
                            "match": "\\\\([\\\\\"nrt]|u\\{?[0-9a-zA-Z]*\\}?)"
                        }
                    ]
                },
                {
                    "name": "string.other.math.typst",
                    "begin": "\\$",
                    "end": "\\$",
                    "captures": {
                        "0": {
                            "name": "punctuation.definition.string.math.typst"
                        }
                    }
                }
            ]
        },
        "arguments": {
            "patterns": [
                {
                    "name": "variable.parameter.typst",
                    "match": "\\b[[:alpha:]_][[:alnum:]_-]*(?=:)"
                },
                {
                    "include": "#code"
                }
            ]
        }
    },
    "scopeName": "source.typst"
}
