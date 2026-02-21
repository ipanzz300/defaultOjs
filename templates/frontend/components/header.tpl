{**
 * Templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 * is set from the plugin which initiates the page.
 *}

{* Determine whether a logo or title string is being displayed *}
{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}

<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

<div class="pkp_structure_page">
	<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">
		{include file="frontend/components/skipLinks.tpl"}

		{* TOP BAR BIRU (Grup menu diletakkan di kanan semua) *}
		<div class="top-simple-bar">
		    <div class="top-simple-content">
		        
		        {* GRUP KIRI: Kosong (Atau bisa untuk teks lain nanti) *}
		        <div class="top-bar-left-group"></div>

		        {* GRUP KANAN: Bahasa + Menu User *}
		        <div class="top-bar-right-group">
		            {if $languageToggleLocales && $languageToggleLocales|@count > 1}
		                <div class="language-switcher-dropdown">
		                    <button class="lang-btn" aria-haspopup="true" aria-expanded="false">
		                        <span class="fa fa-globe"></span>
		                        <span class="current-lang">
		                            {foreach from=$languageToggleLocales item=localeName key=localeKey}
		                                {if $localeKey == $currentLocale}
                                            {if $currentLocale == 'en_US' or $currentLocale == 'en'}
                                                {if $localeKey|substr:0:2 == 'id'}Indonesian{else}English{/if}
                                            {else}
                                                {if $localeKey|substr:0:2 == 'en'}Inggris{else}Bahasa Indonesia{/if}
                                            {/if}
                                        {/if}
		                            {/foreach}
		                        </span>
		                        <span class="fa fa-chevron-down"></span>
		                    </button>
		                    <ul class="lang-list">
		                        {foreach from=$languageToggleLocales item=localeName key=localeKey}
                                    {assign var="navLocaleName" value=$localeName}
                                    {if $currentLocale == 'en_US' or $currentLocale == 'en'}
                                        {if $localeKey|substr:0:2 == 'id'}{assign var="navLocaleName" value="Indonesian"}{else}{assign var="navLocaleName" value="English"}{/if}
                                    {else}
                                        {if $localeKey|substr:0:2 == 'en'}{assign var="navLocaleName" value="Inggris"}{else}{assign var="navLocaleName" value="Bahasa Indonesia"}{/if}
                                    {/if}
		                            <li {if $localeKey == $currentLocale}class="active"{/if}>
		                                <a href="{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}">
		                                    {$navLocaleName}
		                                </a>
		                            </li>
		                        {/foreach}
		                    </ul>
		                </div>
		            {/if}

		            <div class="top-user-menu-wrapper">
		                {load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
		            </div>
		        </div>
		    </div>
		</div>

		<div class="pkp_head_wrapper">
			<div class="pkp_site_name_wrapper">

				<div class="pkp_site_name">
    {capture assign="homeUrl"}{url page="index" router=\PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
    
    <div class="branding-wrapper">
        
        {if $displayPageHeaderLogo}
            <div class="journal-logo-wrapper">
                <a href="{$homeUrl}" class="is_img">
                    <img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt="{translate key="common.pageHeaderLogo.altText"}"{/if} />
                </a>
            </div>
        {else}
            <div class="journal-icon-box">
                {if $currentContext}
                    {* Ambil Variable Nama dan Akronim *}
                    {assign var="journalName" value=$currentContext->getLocalizedName()}
                    {assign var="journalAcronym" value=$currentContext->getLocalizedAcronym()}
                    
                    {* LOGIKA: Prioritas Akronim -> Jika kosong, ambil huruf depan *}
                    {if $journalAcronym}
                        {$journalAcronym|escape}
                    {else}
                        {* Fallback: Ambil Huruf Pertama dari Kata Pertama & Kedua (Misal: Jurnal Teknologi -> JT) *}
                        {$journalName|regex_replace:"/(\b\w)\w+\s?/":"$1"|replace:" ":""|truncate:2:""|upper|escape}
                    {/if}
                {else}
                    {* Default jika bukan halaman jurnal *}
                    OJS
                {/if}
            </div>
        {/if}

        <div class="journal-details">
            {if $displayPageHeaderTitle}
                <a href="{$homeUrl}" class="custom-journal-title">{$displayPageHeaderTitle|escape}</a>
            {else}
                <a href="{$homeUrl}" class="custom-journal-title">{$currentContext->getLocalizedName()|escape}</a>
            {/if}
            
            {if $currentContext}
                <div class="custom-issn-row">
                    {if $currentContext->getData('onlineIssn')}E-ISSN: {$currentContext->getData('onlineIssn')|escape}{/if}
                    {if $currentContext->getData('onlineIssn') && $currentContext->getData('printIssn')} | {/if}
                    {if $currentContext->getData('printIssn')}P-ISSN: {$currentContext->getData('printIssn')|escape}{/if}
                </div>
            {/if}
        </div>
    </div>
</div>
</div> {* Closing pkp_site_name_wrapper *}

	</header>


	<nav class="custom-main-navbar" aria-label="{translate|escape key="common.navigation.site"}">
		<div class="pkp_navigation_primary_wrapper">
			<button class="custom_nav_toggle" id="navToggleBtn">
				<span>{translate key="common.navigation.toggle"}</span>
			</button>
			<div class="custom_nav_menu" id="navMenuContainer">
				{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}

				{if $currentContext && $requestedPage !== 'search'}
					<div class="pkp_navigation_search_wrapper">
						<a href="{url page="search"}" class="pkp_search pkp_search_desktop">
							<span class="fa fa-search"></span> {translate key="common.search"}
						</a>
					</div>
				{/if}
			</div>
		</div>
	</nav>

	{literal}
	<script>
		document.addEventListener('DOMContentLoaded', function() {
			var toggleBtn = document.getElementById('navToggleBtn');
			var navMenu = document.getElementById('navMenuContainer');

			if (toggleBtn && navMenu) {
				toggleBtn.addEventListener('click', function(e) {
					e.preventDefault();
					e.stopPropagation();
					
					// Toggle Classes
					navMenu.classList.toggle('custom_nav_menu--isOpen');
					toggleBtn.classList.toggle('custom_nav_toggle--active');
				});

				// Close when clicking links
				var links = navMenu.getElementsByTagName('a');
				for (var i = 0; i < links.length; i++) {
					links[i].addEventListener('click', function() {
						navMenu.classList.remove('custom_nav_menu--isOpen');
						toggleBtn.classList.remove('custom_nav_toggle--active');
					});
				}
				
				// Close when clicking outside
				document.addEventListener('click', function(event) {
					var isClickInside = toggleBtn.contains(event.target) || navMenu.contains(event.target);
					if (!isClickInside && navMenu.classList.contains('custom_nav_menu--isOpen')) {
						navMenu.classList.remove('custom_nav_menu--isOpen');
						toggleBtn.classList.remove('custom_nav_toggle--active');
					}
				});
			}
		});
	</script>
	{/literal}

	{if $isFullWidth}
		{assign var=hasSidebar value=0}
	{/if}