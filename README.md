# PackageListTool

This tool allows creating package list YML files. It performs the following steps:

1. Fetch package summary descriptions from OpenAI's API for a list of package IDs (in this context: owner/repo pairs).
2. These summaries are stored in a given directory at paths `outdir/owner-repo.txt` and will not be regnerated if a file already exists with that name.
3. Fetch package metadata from the SPI API and merge it with the package summary.

Steps 1+2:

```
package-list-tool generate-descriptions -p apple/swift-argument-parser sindresorhus/settings \
    --open-ai-api-token $OPENAI_TOKEN \
    --github-api-token $GITHUB_TOKEN \
    -o ./descriptions
```

Step 3:

```
package-list-tool generate-package-yml -p apple/swift-argument-parser sindresorhus/settings \
  --spi-api-token $SPI_API_TOKEN \
  --descriptions-directory ./descriptions \
  -o packages.yml
```

