// ====================================================================
// BUCKET ID EXTRACTOR - RUN THIS IN PLANNER CONSOLE
// ====================================================================
//
// INSTRUCTIONS:
// 1. Open your Planner page: https://planner.cloud.microsoft/...
// 2. Press F12 to open DevTools
// 3. Go to the "Console" tab
// 4. Copy and paste this ENTIRE script
// 5. Press Enter
// 6. Copy the output and send it back
// ====================================================================

(async function getBucketIds() {
    console.log('====================================================================');
    console.log('🔍 FETCHING BUCKET IDs FROM PLANNER API...');
    console.log('====================================================================');

    const planId = 'c693904c-956a-4bb9-984e-20e57b622817';
    const apiUrl = `https://graph.microsoft.com/v1.0/planner/plans/${planId}/buckets`;

    try {
        console.log(`📡 Calling: ${apiUrl}`);
        console.log('');

        // Make the API request (browser will use your current auth)
        const response = await fetch(apiUrl, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
            },
            credentials: 'include'
        });

        if (!response.ok) {
            console.error(`❌ Error: ${response.status} ${response.statusText}`);
            const errorData = await response.json();
            console.error('Error details:', errorData);

            console.log('');
            console.log('====================================================================');
            console.log('⚠️ API CALL FAILED - TRY URL METHOD INSTEAD:');
            console.log('====================================================================');
            console.log('1. Click on a task in "Action Items" bucket');
            console.log('2. Look at the URL bar for: &bucketId=XXXXX');
            console.log('3. Copy that bucket ID');
            console.log('4. Repeat for "Missing Information" bucket');
            console.log('5. Send me both bucket IDs');
            console.log('====================================================================');
            return;
        }

        const data = await response.json();

        console.log('✅ SUCCESS! Found buckets:');
        console.log('');
        console.log('====================================================================');
        console.log('📋 YOUR BUCKET IDs:');
        console.log('====================================================================');

        const buckets = {};

        data.value.forEach((bucket, index) => {
            console.log(`${index + 1}. ${bucket.name}`);
            console.log(`   ID: ${bucket.id}`);
            console.log('');
            buckets[bucket.name] = bucket.id;
        });

        console.log('====================================================================');
        console.log('✅ CONFIGURATION FOR YOUR FLOW:');
        console.log('====================================================================');
        console.log('');
        console.log('Team ID: 6cdbd2a2-7e69-492e-ad7e-a617ed1c6597');
        console.log(`Plan ID: ${planId}`);

        if (buckets['Action Items']) {
            console.log(`Action Items Bucket ID: ${buckets['Action Items']}`);
        } else {
            console.log('Action Items Bucket ID: NOT FOUND - Check bucket name');
        }

        if (buckets['Missing Information']) {
            console.log(`Missing Information Bucket ID: ${buckets['Missing Information']}`);
        } else {
            console.log('Missing Information Bucket ID: NOT FOUND - Check bucket name');
        }

        console.log('');
        console.log('====================================================================');
        console.log('📋 COPY THE OUTPUT ABOVE AND SEND IT BACK!');
        console.log('====================================================================');

        // Also create a nice JSON object for easy copying
        const config = {
            teamId: '6cdbd2a2-7e69-492e-ad7e-a617ed1c6597',
            planId: planId,
            actionItemsBucketId: buckets['Action Items'] || 'NOT_FOUND',
            missingInfoBucketId: buckets['Missing Information'] || 'NOT_FOUND',
            allBuckets: data.value.map(b => ({ name: b.name, id: b.id }))
        };

        console.log('');
        console.log('JSON Config (copy this):');
        console.log(JSON.stringify(config, null, 2));

        // Try to copy to clipboard
        try {
            await navigator.clipboard.writeText(JSON.stringify(config, null, 2));
            console.log('');
            console.log('✅ Configuration copied to clipboard!');
        } catch (e) {
            console.log('');
            console.log('⚠️ Could not copy to clipboard automatically');
        }

    } catch (error) {
        console.error('❌ FETCH FAILED:', error);
        console.log('');
        console.log('====================================================================');
        console.log('⚠️ ALTERNATIVE METHOD - GET IDs FROM URLs:');
        console.log('====================================================================');
        console.log('The API call failed. Try this instead:');
        console.log('');
        console.log('1. In Planner, create a test task in "Action Items"');
        console.log('2. Click on that task');
        console.log('3. Copy the URL from your browser address bar');
        console.log('4. Send me that URL');
        console.log('5. Repeat for "Missing Information" bucket');
        console.log('');
        console.log('I will extract the bucket IDs from those URLs!');
        console.log('====================================================================');
    }
})();

// ====================================================================
// After running this script, copy ALL the console output and paste it
// back to Claude Code. It will have your bucket IDs!
// ====================================================================
