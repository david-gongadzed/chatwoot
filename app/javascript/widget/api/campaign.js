import endPoints from 'widget/api/endPoints';
import { API } from 'widget/helpers/axios';

const getCampaigns = async websiteToken => {
  const urlData = endPoints.getCampaigns(websiteToken);
    const result = await API.get(urlData.url, { params: urlData.params });
    let pagename = new URLSearchParams(window.location.search).get('page_title').split("|")[0].trim();
    result.data.forEach(function(ii){
        ii.message = ii.message.replace("{{page-name}}", pagename);
    });
  return result;
};

const triggerCampaign = async ({
  campaignId,
  websiteToken,
  customAttributes,
}) => {
  const urlData = endPoints.triggerCampaign({
    websiteToken,
    campaignId,
    customAttributes,
  });
  await API.post(
    urlData.url,
    { ...urlData.data },
    {
      params: urlData.params,
    }
  );
};
export { getCampaigns, triggerCampaign };
