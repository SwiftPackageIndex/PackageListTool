# PackageListTool

This tool allows creating package list YML files. It has two subcommands:

- `generate-descriptions`
- `generate-packages-yml`

`generate-descriptions` fetches package summary descriptions from OpenAI's API for a list of package IDs (in this context: owner/repo pairs). These summaries are stored in a given directory at paths `outdir/owner-repo.txt` and will not be regnerated if a file already exists with that name.

`generate-packages-yml` does the same as `generate-descriptions` and also fetches package metadata from the SPI API and merges it with the package summary. `generate-packages-yml` will use previously generated summaries in the specified `descriptions-directory` instead of making API calls to ChatGPT if it finds a description for a referenced package.

## Examples

```
package-list-tool generate-descriptions -p apple/swift-nio Alamofire/Alamofire \
    --open-ai-api-token $OPENAI_TOKEN \
    --github-api-token $GITHUB_TOKEN \
    --descriptions-directory ./descriptions
```

```
package-list-tool generate-packages-yml \
    --open-ai-api-token $OPENAI_TOKEN \
    --github-api-token $GITHUB_TOKEN \
    --spi-api-token $SPI_API_TOKEN \
    --descriptions-directory ./descriptions \
    -s source_template.yml \
    -o packages.yml
```
