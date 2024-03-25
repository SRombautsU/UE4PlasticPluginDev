// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;
using System.Collections.Generic;

public class UE4PlasticPluginDevEditorTarget : TargetRules
{
	public UE4PlasticPluginDevEditorTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Editor;
		DefaultBuildSettings = BuildSettingsVersion.V2;

		// TODO Required for building with UE5.4
//		DefaultBuildSettings = BuildSettingsVersion.V5;
		WindowsPlatform.bStrictConformanceMode = true;

		ExtraModuleNames.Add("UE4PlasticPluginDev");

        // Uncomment to rebuild the whole project without Unity Build, compiling each cpp source file individually, in order to test Includ Whay You Use (IWYU) policy
        // WARNING: don't uncomment on UnrealEngine Source Build, else you will trigger a full new Engine build (but easy to revert, will just relink 1200 lib/dll)
        bUseUnityBuild = false;
	}
}
