{
    "lenses": {
        "0": {
            "order": 0,
            "parts": {
                "0": {
                    "position": {
                        "x": 0,
                        "y": 0,
                        "colSpan": 2,
                        "rowSpan": 4
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "partTitle",
                                "value": "Query 1",
                                "isOptional": true
                            },
                            {
                                "name": "chartType",
                                "isOptional": true
                            },
                            {
                                "name": "isShared",
                                "isOptional": true
                            },
                            {
                                "name": "queryId",
                                "isOptional": true
                            },
                            {
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                },
                                "isOptional": true
                            },
                            {
                                "name": "query",
                                "value": "Resources\n| extend createdOn = todatetime(tags.CreatedOn)\n| extend age  = now() - createdOn\n| count",
                                "isOptional": true
                            },
                            {
                                "name": "formatResults",
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/HubsExtension/PartType/ArgQuerySingleValueTile",
                        "settings": {
                            "content": {}
                        },
                        "partHeader": {
                            "title": "All Resources",
                            "subtitle": "A Count of All Resources"
                        }
                    }
                },
                "1": {
                    "position": {
                        "x": 2,
                        "y": 0,
                        "colSpan": 6,
                        "rowSpan": 4
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "partTitle",
                                "value": "Query 1",
                                "isOptional": true
                            },
                            {
                                "name": "chartType",
                                "isOptional": true
                            },
                            {
                                "name": "isShared",
                                "isOptional": true
                            },
                            {
                                "name": "queryId",
                                "isOptional": true
                            },
                            {
                                "name": "formatResults",
                                "isOptional": true
                            },
                            {
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                },
                                "isOptional": true
                            },
                            {
                                "name": "query",
                                "value": "Resources\r\n| extend createdOn = todatetime(tags.CreatedOn)\r\n| extend age  = now() - createdOn\r\n| summarize by id, type, age\r\n| order by age desc",
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/HubsExtension/PartType/ArgQueryGridTile",
                        "settings": {
                            "content": {}
                        },
                        "partHeader": {
                            "title": "Resources List",
                            "subtitle": "A List Of All Resources"
                        }
                    }
                },
                "2": {
                    "position": {
                        "x": 8,
                        "y": 0,
                        "colSpan": 7,
                        "rowSpan": 4
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "isShared",
                                "isOptional": true
                            },
                            {
                                "name": "queryId",
                                "isOptional": true
                            },
                            {
                                "name": "formatResults",
                                "isOptional": true
                            },
                            {
                                "name": "partTitle",
                                "value": "Query 1",
                                "isOptional": true
                            },
                            {
                                "name": "query",
                                "value": "// top ten resource types by number of resources\nsummarize ResourceCount=count() by type\n| order by ResourceCount desc\n| take 10\n| project [\"Resource Type\"]=type, [\"Resource Count\"]=ResourceCount",
                                "isOptional": true
                            },
                            {
                                "name": "chartType",
                                "value": 1,
                                "isOptional": true
                            },
                            {
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                },
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/HubsExtension/PartType/ArgQueryChartTile",
                        "settings": {},
                        "partHeader": {
                            "title": "Resources By Type",
                            "subtitle": "A Chart Of Resources By Type"
                        }
                    }
                },
                "3": {
                    "position": {
                        "x": 0,
                        "y": 4,
                        "colSpan": 2,
                        "rowSpan": 4
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "chartType",
                                "isOptional": true
                            },
                            {
                                "name": "isShared",
                                "isOptional": true
                            },
                            {
                                "name": "queryId",
                                "isOptional": true
                            },
                            {
                                "name": "partTitle",
                                "value": "Query 1",
                                "isOptional": true
                            },
                            {
                                "name": "query",
                                "value": "Resources\n| extend createdOn = todatetime(tags.CreatedOn)\n| extend age  = now() - createdOn\n| where age > totimespan(7d)\n| count",
                                "isOptional": true
                            },
                            {
                                "name": "formatResults",
                                "value": true,
                                "isOptional": true
                            },
                            {
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                },
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/HubsExtension/PartType/ArgQuerySingleValueTile",
                        "settings": {},
                        "partHeader": {
                            "title": "Old Resources",
                            "subtitle": "Resources Older Than Seven Days"
                        }
                    }
                },
                "4": {
                    "position": {
                        "x": 2,
                        "y": 4,
                        "colSpan": 6,
                        "rowSpan": 4
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "chartType",
                                "isOptional": true
                            },
                            {
                                "name": "isShared",
                                "isOptional": true
                            },
                            {
                                "name": "queryId",
                                "isOptional": true
                            },
                            {
                                "name": "formatResults",
                                "isOptional": true
                            },
                            {
                                "name": "partTitle",
                                "value": "Query 1",
                                "isOptional": true
                            },
                            {
                                "name": "query",
                                "value": "Resources\r\n| extend createdOn = todatetime(tags.CreatedOn)\r\n| extend age  = now() - createdOn\r\n| where age > totimespan(7d)\r\n| summarize by id, type, age\r\n| order by age desc",
                                "isOptional": true
                            },
                            {
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                },
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/HubsExtension/PartType/ArgQueryGridTile",
                        "settings": {},
                        "partHeader": {
                            "title": "Old Resources List",
                            "subtitle": "A List of Expired Resources"
                        }
                    }
                },
                "5": {
                    "position": {
                        "x": 8,
                        "y": 4,
                        "colSpan": 7,
                        "rowSpan": 4
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "partTitle",
                                "value": "Query 1",
                                "isOptional": true
                            },
                            {
                                "name": "chartType",
                                "value": 1,
                                "isOptional": true
                            },
                            {
                                "name": "isShared",
                                "isOptional": true
                            },
                            {
                                "name": "queryId",
                                "isOptional": true
                            },
                            {
                                "name": "formatResults",
                                "isOptional": true
                            },
                            {
                                "name": "queryScope",
                                "value": {
                                    "scope": 0,
                                    "values": []
                                },
                                "isOptional": true
                            },
                            {
                                "name": "query",
                                "value": "Resources\n| extend createdOn = todatetime(tags.CreatedOn)\n| extend age  = now() - createdOn\n| where age > totimespan(7d)\n| summarize count() by type\n",
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/HubsExtension/PartType/ArgQueryChartTile",
                        "settings": {
                            "content": {}
                        },
                        "partHeader": {
                            "title": "Old Resources By Type",
                            "subtitle": ""
                        }
                    }
                },
                "6": {
                    "position": {
                        "x": 0,
                        "y": 8,
                        "colSpan": 2,
                        "rowSpan": 2
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/Microsoft_AAD_IAM/PartType/UserManagementSummaryPart",
                        "partHeader": {
                            "title": "Active Users"
                        }
                    }
                },
                "7": {
                    "position": {
                        "x": 2,
                        "y": 8,
                        "colSpan": 4,
                        "rowSpan": 2
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "userObjectId",
                                "isOptional": true
                            },
                            {
                                "name": "startDate",
                                "isOptional": true
                            },
                            {
                                "name": "endDate",
                                "isOptional": true
                            },
                            {
                                "name": "fromAppsTile",
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/Microsoft_AAD_IAM/PartType/UsersActivitySummaryReportPart"
                    }
                }
            }
        }
    },
    "metadata": {
        "model": {
            "timeRange": {
                "value": {
                    "relative": {
                        "duration": 24,
                        "timeUnit": 1
                    }
                },
                "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
            }
        }
    }
}