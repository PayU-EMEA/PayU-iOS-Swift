# Developers Process

## How to implement bugfix/feature?

### Step 1

Create branch for feature, bugfix, etc. from `main` branch:

* for ex.: `feature/92-add-new-payment-method-support`
* for ex.: `bugfix/114-the-placeholder-for-card-cvv-is-incorrect`

### Step 2

Make changes:

1. Make changes in `Sources` folder for package
2. Update `Example` app (optional)
3. Run `Example` app (optional)
4. Push changes to your branch

### Step 3

Update tests:

1. Update tests in `Tests` folder
2. Run tests in `Tests` folder
3. Push changes to your branch

### Step 4

Update documentation:

1. Write Symbol Documentation in Your Source Files (changes) according to [docc](https://www.swift.org/documentation/docc)
2. Update stucture in `{Package}/Documentation/Documentation` (optional)
3. Update stucture in `{Package}/Documentation/GettingStartedWith{Package}ExampleOf...` (optional)
4. Update stucture in `PUSDK/Documentation/Documentation` (optional)
5. Update stucture in `PUSDK/Documentation/Articles/GettingStartedWith{Package}` (optional)
6. Update stucture in `PUSDK/Documentation/Articles/GettingStartedWith{Package}ExampleOf...` (optional)
7. Push changes to your branch

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
4. Ensure `docs` folder appears in the project root folder 
5. Push changes to your branch

## How to make release? 

### Step 1

1. Make pull request into `main` branch from your branch
2. Merge your branch into `main` branch
3. Push `tag` with new version to `main` branch
