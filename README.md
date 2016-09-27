# ![alt text] (https://github.com/WishCanTaiwan/VocabuLazy/raw/master/app/src/main/res/mipmap-hdpi/launcher_icon.png) VocabuLazy-iOS 
-
### Project Structure
* **Swallow**

	>* __*Swallow*__
		* __*Models*__
			* WCSearchViewModel.swift
			* WCListViewModel.swift
			* WCVocabularyModel.swift
			* WCSettingContentModel.swift 
		* __*LocalStorage*__
			* StorageManager.swift
			* Vocabulary.json
		* __*ViewControllers*__
			* __*HOME*__
				* WCMainViewController.swift
			* __*UNIT*__
				* WCLessonChooseViewController.swift
			* __*SEARCH*__
				* WCSearchViewController.swift
				* __*WCSearchView*__
			* __*PLAYLIST*__
				* WCWordPlayViewController.swift
				* __*WCWordPlayScrollView*__
				* __*WCWordPlayTableView*__
				* __*WCWordGroundHandle*r__
				* __*WCWordPlaySettingView*__
			* __*LIST*__
				* WCListViewController.swift
					* __*WCListEmptyView*__
					* __*WCSegmentTapView*__
					* __*WCPopView*__
			* __*EXAM*__
				* WCExamViewController.swift
				* __*單元練習*__
					* EHomeViewController.swift
					* WCExamChooseViewController.swift
				* __*清單測驗*__
					* EListTableViewController.swift
					* WCExamChooseViewController.swift
				* __*WCQuestionAnswerView*__
				* __*WCQuestionTitleView*__
				* __*WCQuestionCollectionView*__
				* __*WCExamResultView*__
			* __*INFO*__
				* WCInformationViewController.swift
		* __*CustomLibraries*__
			* __*WCColor*__
			* __*WCWordSpeechPlayer*__
			* __*WCMaterialButton*__
		* __*ThirdParties*__
			* __*Fonts*__
		* AppDelegate.swift
		* Main.storyboard
		* LaunchScreen.xib
		* __*Images.xcassets*__
		* __*Supporting Files*__
			* Info.plist
	>* __*SwallowTests*__
	>* __*Products*__
	>* __*Frameworks*__

-