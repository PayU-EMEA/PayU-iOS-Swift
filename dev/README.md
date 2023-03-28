# Developers Process

## How to implement bugfix/feature?

### Step 1

Create branch for feature, bugfix, etc. from `release/2.0.0` branch:

* for ex.: `feature/92-add-new-payment-method-support`
* for ex.: `bugfix/114-the-placeholder-for-card-cvv-is-incorrect`

### Step 2

Make changes:

1. make changes in `Sources` folder for package
2. update `Example` app (optional)
3. run `Example` app (optional)
4. push changes to your branch

### Step 3

Update tests:

1. update tests in `Tests` folder
2. run tests in `Tests` folder
3. push changes to your branch

### Step 4

Update documentation:

1. Write Symbol Documentation in Your Source Files (changes) according to [docc](https://www.swift.org/documentation/docc)
2. Update stucture in `{Package}/Documentation/Documentation` (optional)
3. Update stucture in `{Package}/Documentation/GettingStartedWith{Package}ExampleOf...` (optional)
4. Update stucture in `PUSDK/Documentation/Documentation` (optional)
5. Update stucture in `PUSDK/Documentation/Articles/GettingStartedWith{Package}` (optional)
6. Update stucture in `PUSDK/Documentation/Articles/GettingStartedWith{Package}ExampleOf...` (optional)
7. push changes to your branch

> Note: Ensure documentation is correct: `XCode > Product > Build Documentation`

## How to prepare for Release?

### Step 1

Ensure all tests passed: 

1. Open `Terminal` app
2. Navigate to Project Root Folder, for ex: `cd /Path/To/Project/Root/Folder/`
3. Run `make generate_mocks` command in `Terminal`
4. Run `make xcodebuild_test` command in `Terminal`

### Step 2

1. Update `README.md` in the project root folder
2. Update `Changelog.md` in the project root folder

### Step 3

Generate documentation: 

1. Open `Terminal` app
2. Navigate to Project Root Folder, for ex: `cd /Path/To/Project/Root/Folder/`
3. Run `make generate_documentation` command.
4. Ensure `docs` folder appears in 
5. push changes to your branch

## How to make release? 

### Step 1

1. make pull request into `release/2.0.0` branch from your branch
2. merge your branch into `release/2.0.0` branch
3. push `tag` with new version to `release/2.0.0` branch
