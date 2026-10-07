# The Tercen unit test

`tests/test.json` is a **pinned smoke test**, not a scientific test suite. It proves that a release installs, starts, reads its crosstab projection and reproduces the output it produced when the golden files were made. The release workflow's install check and the Tercen library gate both run it; a release without a passing test is red, and the operator cannot be published to a library.

## How the runner compares (sci `OperatorService.runUnitTest`)

- **Discovery.** Every `*.json` file in `tests/` is one test, and its outputs are **compared** to the expected files. A folder named `test/` (singular) instead runs the tests **without comparing any output**. With neither folder the check fails with `operator.run.test.not.found`.
- **Order of checks.** Number of output relations, then number of columns, then number of rows, then column names, then column types, then values.
- **Rows are compared by position.** The operator must produce its rows in a deterministic order.
- **Values.** String and int32 columns must match exactly. Double columns are compared per column by R² when `"equalityMethod": "R2"` (pass if R² >= `r2`, typically 0.99). Without `equalityMethod` the comparison uses strict absolute/relative tolerances, which floating-point output rarely survives.
- **`skipColumns`** skips the **values** of the named columns only. A skipped column must still exist in the output with the same type. Use it for values that change on every run: uploaded document ids, random temporary filenames, the base64 bytes of a plot (`.content`).
- **`inputFileUris`** uploads each listed file as a Tercen document and replaces its **filename** in the input CSV with the new document id (for operators that read uploaded files).
- **`propertyValues`** pins the operator's settings for the test (`{"kind": "PropertyValue", "name": "<property>", "value": "<value>"}`). Pin every property explicitly, including database versions and the random seed, so a change of default does not silently change the test.

## Files

- `tests/test.json`: the test (projection, settings, expected outputs, comparison method).
- `tests/<input>.csv`: the input data.
- `tests/<output>.csv`: one expected output per output relation, **from a real run**. They cannot be written by hand.
- `tests/<output>.csv.schema`: recommended for each expected output. It is the relation's schema as exported, and pins the column types (CSV alone cannot tell an int32 from a double).

## Making or regenerating the expected outputs

1. In Tercen Studio (local), import `tests/<input>.csv` and set up the step exactly as `test.json` describes: same projection, every property at its pinned value.
2. Run the operator **twice**. Export each output relation as CSV, plus its schema as a `.csv.schema` sidecar.
3. Compare the two runs. Any column that differs between them is not deterministic: fix the cause (for example seed the random number generator) or list the column in `skipColumns`.
4. Replace the expected files, commit, and tag a release. The release install check runs the test.

Plot operators: the plot is an output relation with a filename, a MIME type and the image bytes in `.content` (base64). Compare it as a smoke test, with `.content` (and the filename, if it is a random temporary name) in `skipColumns`. If the two runs in step 3 give identical bytes, you may keep `.content` in the comparison.
